//
//  ChatViewController.swift
//  ThriveUp
//
//  Created by palak seth on 13/11/24.
//

import UIKit

class ChatViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    let chatDataSource = ChatDataSource() // The data source for chat threads
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
            }
}

extension ChatViewController {
    func setupNavigationBar() {
        navigationItem.title = "Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let friendsButtonView = createFriendsButtonView()
        let friendsButton = UIBarButtonItem(customView: friendsButtonView)
        navigationItem.rightBarButtonItem = friendsButton
    }
    
    private func createFriendsButtonView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        let iconImageView = UIImageView(image: UIImage(named: "friends_icon"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        iconImageView.center = containerView.center
        containerView.addSubview(iconImageView)
        
        let badgeLabel = UILabel()
        badgeLabel.text = "5" // Example badge count
        badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .systemRed
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.clipsToBounds = true
        badgeLabel.frame = CGRect(x: iconImageView.frame.maxX - 10, y: iconImageView.frame.minY - 5, width: 20, height: 20)
        containerView.addSubview(badgeLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(friendsTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.isUserInteractionEnabled = true

        return containerView
    }
    
    @objc func friendsTapped() {
        let addFriendsVC = AddFriendsViewController()
        let navController = UINavigationController(rootViewController: addFriendsVC)
        navController.modalPresentationStyle = .pageSheet
        navController.isModalInPresentation = true
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(navController, animated: true, completion: nil)
    }
}

extension ChatViewController {
    func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")
        tableView.rowHeight = 80
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100) // Space for tab bar
        ])
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDataSource.threads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else {
            return UITableViewCell()
        }
        
        let thread = chatDataSource.threads[indexPath.row]
        let lastMessage = thread.messages.last
        let otherParticipant = thread.participants.first { $0.name != "Current User" }
        
        cell.configure(
            with: otherParticipant?.name ?? "Unknown",
            message: lastMessage?.messageContent ?? "",
            time: formattedTime(from: lastMessage?.timestamp ?? Date()),
            profileImage: otherParticipant?.profileImage
        )
        return cell
    }
    
    private func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        } else {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedThread = chatDataSource.threads[indexPath.row]
        let chatDetailVC = ChatDetailViewController()
        chatDetailVC.chatThread = selectedThread
        navigationController?.pushViewController(chatDetailVC, animated: true)
    }
}

extension ChatViewController {
    func setupTabBar() {
        let tabBar = UITabBar()
        let feedItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "rectangle.grid.1x2"), tag: 0)
        let chatItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message"), tag: 1)
        let swipeItem = UITabBarItem(title: "Swipe", image: UIImage(systemName: "rectangle.on.rectangle.angled"), tag: 2)
        let calendarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 3)
        let profileItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        
        tabBar.items = [feedItem, chatItem, swipeItem, calendarItem, profileItem]
        tabBar.selectedItem = chatItem
        tabBar.tintColor = .systemOrange
        
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}


