//
//  RegistrationsListViewController.swift
//  ThriveUp
//
//  Created by palak seth on 15/12/24.
//
import UIKit
import FirebaseFirestore

class RegistrationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    private var registrations: [[String: Any]] = [] // Holds fetched registrations data
    private let eventId: String
    private let db = Firestore.firestore()
    
    // MARK: - UI Components
    private let tableViewHeader: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8

        let headers = ["S.No", "Name", "Email", "Year"]
        for header in headers {
            let label = UILabel()
            label.text = header
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .black
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    private let registrationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RegistrationCell")
        return tableView
    }()
    
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download File", for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Initializer
    init(eventId: String) {
        self.eventId = eventId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        fetchRegistrations()
        downloadButton.addTarget(self, action: #selector(handleDownload), for: .touchUpInside)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        title = "Registrations"
        view.backgroundColor = .white
        view.addSubview(totalCountLabel)
        view.addSubview(tableViewHeader)
        view.addSubview(registrationsTableView)
        view.addSubview(downloadButton)
        
        registrationsTableView.delegate = self
        registrationsTableView.dataSource = self
    }
    
    private func setupConstraints() {
        tableViewHeader.translatesAutoresizingMaskIntoConstraints = false
        registrationsTableView.translatesAutoresizingMaskIntoConstraints = false
        totalCountLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Total Count Label
            totalCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            totalCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Table Header
            tableViewHeader.topAnchor.constraint(equalTo: totalCountLabel.bottomAnchor, constant: 8),
            tableViewHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewHeader.heightAnchor.constraint(equalToConstant: 30),
            
            // TableView
            registrationsTableView.topAnchor.constraint(equalTo: tableViewHeader.bottomAnchor, constant: 8),
            registrationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registrationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registrationsTableView.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -16),
            
            // Download Button
            downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            downloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            downloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Fetch Registrations
    private func fetchRegistrations() {
        db.collection("registrations").document(eventId).collection("registrations").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching registrations: \(error)")
                return
            }
            
            self.registrations = snapshot?.documents.compactMap { $0.data() } ?? []
            DispatchQueue.main.async {
                self.totalCountLabel.text = "Total Number of Registrations: \(self.registrations.count)"
                self.registrationsTableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registration = registrations[indexPath.row]
        
        let serialNumber = indexPath.row + 1
        let name = registration["Name"] as? String ?? "N/A"
        let email = registration["E-mail ID"] as? String ?? "N/A"
        let year = registration["Year of Study"] as? String ?? "N/A"
        
        cell.textLabel?.text = "\(serialNumber)\t\t\(name)\t\t\(email)\t\t\(year)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.numberOfLines = 1
        
        return cell
    }
    
    // MARK: - Download Button Action
    @objc private func handleDownload() {
        let csvData = generateCSVData()
        let fileName = "registrations_event_\(eventId).csv"
        
        let fileManager = FileManager.default
        let tempURL = fileManager.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try csvData.write(to: tempURL, atomically: true, encoding: .utf8)
            let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            present(activityViewController, animated: true)
        } catch {
            print("Error writing CSV file: \(error.localizedDescription)")
        }
    }
    
    private func generateCSVData() -> String {
        var csvString = "S.No,Name,Email,Year\n" // Header row
        
        for (index, registration) in registrations.enumerated() {
            let serialNumber = index + 1
            let name = registration["Name"] as? String ?? "N/A"
            let email = registration["E-mail ID"] as? String ?? "N/A"
            let year = registration["Year of Study"] as? String ?? "N/A"
            
            csvString += "\(serialNumber),\"\(name)\",\"\(email)\",\"\(year)\"\n"
        }
        
        return csvString
    }
}

class RegistrationTableViewCell: UITableViewCell {
    
    static let identifier = "RegistrationTableViewCell"
    
    // MARK: - UI Components
    private let serialNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(serialNumberLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(yearLabel)
        
        serialNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Serial Number
            serialNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            serialNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            serialNumberLabel.widthAnchor.constraint(equalToConstant: 50),
            
            // Name Label
            nameLabel.leadingAnchor.constraint(equalTo: serialNumberLabel.trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: yearLabel.leadingAnchor, constant: -8),
            
            // Email Label (under name)
            emailLabel.leadingAnchor.constraint(equalTo: serialNumberLabel.trailingAnchor, constant: 8),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.trailingAnchor.constraint(equalTo: yearLabel.leadingAnchor, constant: -8),
            emailLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            // Year Label
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            yearLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            yearLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(with registration: [String: Any], index: Int) {
        serialNumberLabel.text = "\(index + 1)"
        let name = registration["Name"] as? String ?? "N/A"
        let email = registration["E-mail ID"] as? String ?? "N/A"
        let year = registration["Year of Study"] as? String ?? "N/A"
    }
}
