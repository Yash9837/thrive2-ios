//
//  RegistrationsListViewController.swift
//  ThriveUp
//
//  Created by palak seth on 15/12/24.
//

import UIKit
import FirebaseFirestore

class RegistrationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private let db = Firestore.firestore() // Firestore instance
    private var eventId: String // Event ID to fetch registrations
    private var registrations: [[String: Any]] = [] // Array to store registration data
    
    // MARK: - Initializer
    init(eventId: String) {
        self.eventId = eventId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchRegistrations()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Registrations"
        
        // Configure table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RegistrationCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Fetch Registrations
    private func fetchRegistrations() {
        db.collection("registrations")
            .document(eventId)
            .collection("registrations")
            .order(by: "timestamp", descending: true) // Sort by latest registration
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching registrations: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No registrations found")
                    return
                }
                
                self?.registrations = documents.map { $0.data() }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registration = registrations[indexPath.row]
        
        // Customize cell with registration details
        let name = registration["Name"] as? String ?? "No Name"
        let email = registration["E-mail ID"] as? String ?? "No Email"
        cell.textLabel?.text = "\(name) - \(email)"
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    // MARK: - UITableViewDelegate (optional)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let registration = registrations[indexPath.row]
        print("Selected registration: \(registration)")
    }
}
