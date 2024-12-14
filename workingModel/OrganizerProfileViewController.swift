//
//  OrganizerProfileViewController.swift
//  ThriveUp
//
//  Created by Yash's Mackbook on 19/11/24.
//

import UIKit

class OrganizerProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    private var createdEvents: [EventModel] = [] // Stores events created by the organizer

    // UI Elements
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AarushIn") // Replace with your image name
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Organizer Name"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "organizer@example.com"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
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
        label.text = "Passionate organizer creating amazing experiences for the community."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        return tableView
    }()
    
    private let createEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create New Event", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(createEventTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupUI()
        setupConstraints()
        loadCreatedEvents()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(aboutLabel)
        view.addSubview(aboutDescriptionLabel)
        view.addSubview(eventsTableView)
        view.addSubview(createEventButton)
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
    }
    
    private func setupConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        eventsTableView.translatesAutoresizingMaskIntoConstraints = false
        createEventButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            aboutLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            aboutDescriptionLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 8),
            aboutDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            aboutDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            eventsTableView.topAnchor.constraint(equalTo: aboutDescriptionLabel.bottomAnchor, constant: 16),
            eventsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: createEventButton.topAnchor, constant: -16),
            
            createEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            createEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            createEventButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createEventButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Load Created Events
    private func loadCreatedEvents() {
        // Placeholder for fetching created events
        createdEvents = [
            EventModel(eventId: "1", title: "Samay Raina", category: "Cultural", attendanceCount: 100, organizerName: "Tech Group", date: "Dec 10", time: "10:00 AM", location: "Conference Hall", locationDetails: "Building A", imageName: "SamayRaina", speakers: [], description: "An insightful tech conference."),
            EventModel(eventId: "2", title: "Music Fest", category: "Cultural", attendanceCount: 300, organizerName: "Music Club", date: "Jan 20", time: "6:00 PM", location: "Main Lawn", locationDetails: "City Center", imageName: "DShack", speakers: [], description: "An evening of fun and music.")
        ]
        eventsTableView.reloadData()
    }

    // MARK: - Navigation Bar Configuration
    private func configureNavigationBar() {
        navigationItem.title = "Aaruush"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        
        // Add Logout Button
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        logoutButton.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.systemBlue
        ], for: .normal)
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    // MARK: - Logout Handler
    @objc private func handleLogout() {
        let loginVC = LoginViewController()
        
        // Set the login screen as the root view controller
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: loginVC)
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

    // MARK: - Create Event Button Action
    @objc private func createEventTapped() {
        let createEventVC = PostEventViewController() // Navigate to PlanEventViewController
        navigationController?.pushViewController(createEventVC, animated: true)
    }

    // MARK: - UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createdEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let event = createdEvents[indexPath.row]
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = "\(event.date) at \(event.time)"
        cell.imageView?.image = UIImage(named: event.imageName) // Replace with actual images
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVC = EventDetailViewController()
        eventDetailVC.event = createdEvents[indexPath.row]
        navigationController?.pushViewController(eventDetailVC, animated: true)
    }
}
