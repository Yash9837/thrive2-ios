//
//  ProfileViewController.swift
//  ThriveUp
//
//  Created by Yash's Mackbook on 16/11/24.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    private var registeredEvents: [EventModel] = [] // Stores registered events
    private let categories: [CategoryModel] // Categories to filter events by ID
    
    // UI Elements
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "yash_profile") // Replace with your image name
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Yash"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "psdedfe@gmail.com"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Details", "Events"])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = UIColor.orange
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let aboutDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Passionate college student who thrives on new experiences, attending events, and connecting with people."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private let eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RegisteredEventCell.self, forCellReuseIdentifier: RegisteredEventCell.identifier) // Updated to RegisteredEventCell
        tableView.isHidden = true // Initially hidden until "Events" segment is selected
        return tableView
    }()
    
    // MARK: - Initializer
    init(categories: [CategoryModel]) {
        self.categories = categories
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        setupUI()
        setupConstraints()
        loadRegisteredEvents()
        print("ProfileViewController loaded.")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(segmentControl)
        view.addSubview(aboutLabel)
        view.addSubview(aboutDescriptionLabel)
        view.addSubview(detailsStackView)
        view.addSubview(eventsTableView)
        
        // Add detail views
        let yearView = createDetailView(title: "III", value: "YEAR")
        let departmentView = createDetailView(title: "DSBS", value: "DEPARTMENT")
        let friendsView = createDetailView(title: "50+", value: "FRIENDS")
        [yearView, departmentView, friendsView].forEach { detailsStackView.addArrangedSubview($0) }
        
        // Set table view data source and delegate
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
    }
    
    private func setupConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        eventsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            segmentControl.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            aboutLabel.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            aboutDescriptionLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 8),
            aboutDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            aboutDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            detailsStackView.topAnchor.constraint(equalTo: aboutDescriptionLabel.bottomAnchor, constant: 20),
            detailsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            eventsTableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            eventsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createDetailView(title: String, value: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .orange
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }
    
    // MARK: - Load Registered Events
    private func loadRegisteredEvents() {
        print("Loading registered events...")

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found.")
            return
        }

        let fileURL = documentsDirectory.appendingPathComponent("RegisteredEvent.json")
        print("File URL: \(fileURL)")

        do {
            let data = try Data(contentsOf: fileURL)
            print("File data loaded: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
            
            // Decode the registered events directly
            registeredEvents = try JSONDecoder().decode([EventModel].self, from: data)
            print("Registered Events: \(registeredEvents)")
            eventsTableView.reloadData()
        } catch {
            print("Error loading registration data: \(error)")
        }
    }



    
    // MARK: - Configure Navigation Bar
    private func configureNavigationBar() {
        navigationItem.title = "Profile"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        logoutButton.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.systemBlue
        ], for: .normal)
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc private func handleLogout() {
        let userTabBarController = GeneralTabbarController()
        
        // Change the window's root view controller
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = userTabBarController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: - Segment Control Action
        @objc private func segmentChanged() {
            let isShowingEvents = segmentControl.selectedSegmentIndex == 1
            aboutLabel.isHidden = isShowingEvents
            aboutDescriptionLabel.isHidden = isShowingEvents
            detailsStackView.isHidden = isShowingEvents
            eventsTableView.isHidden = !isShowingEvents
            loadRegisteredEvents()

            
        }

    // MARK: - UITableView DataSource & Delegate
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegisteredEventCell.identifier, for: indexPath) as! RegisteredEventCell
        let event = registeredEvents[indexPath.row]
        cell.configure(with: event)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVC = EventDetailViewController()
        eventDetailVC.event = registeredEvents[indexPath.row]
        navigationController?.pushViewController(eventDetailVC, animated: true)
    }
}
