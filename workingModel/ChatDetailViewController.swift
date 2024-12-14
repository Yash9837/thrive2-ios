//
//  ChatDetailViewController.swift
//  ThriveUp
//
//  Created by palak seth on 15/11/24.
//

import UIKit

class ChatDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var chatThread: ChatThread? // Thread containing messages and participants
    
    private let tableView = UITableView()
    private let messageInputBar = UIView()
    private let inputTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCustomTitleView()
        setupMessageInputComponents()
        setupTableView()
    }
    
    private func setupCustomTitleView() {
        // Ensure participant exists
        guard let participant = chatThread?.participants.first(where: { $0.id != "currentUser" }) else {
            print("No participant found other than the current user.")
            return
        }
        
        // Create container view for title
        let titleView = UIView()
        
        // Profile Image View
        let profileImageView = UIImageView(image: participant.profileImage)
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Name Label
        let nameLabel = UILabel()
        nameLabel.text = participant.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Debugging: Add temporary background colors
        titleView.backgroundColor = .clear
        profileImageView.backgroundColor = .lightGray
        nameLabel.backgroundColor = .yellow
        
        // Add subviews
        titleView.addSubview(profileImageView)
        titleView.addSubview(nameLabel)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: titleView.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            nameLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
        
        // Set intrinsic content size for titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            titleView.heightAnchor.constraint(equalToConstant: 100) // Adjust as needed
        ])
        
        // Assign custom title view
        navigationItem.titleView = titleView
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    private func setupMessageInputComponents() {
        messageInputBar.backgroundColor = .systemGray6
        view.addSubview(messageInputBar)
        
        messageInputBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageInputBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        inputTextField.placeholder = "Message"
        inputTextField.borderStyle = .roundedRect
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        messageInputBar.addSubview(inputTextField)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        messageInputBar.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: messageInputBar.leadingAnchor, constant: 16),
            inputTextField.centerYAnchor.constraint(equalTo: messageInputBar.centerYAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.trailingAnchor.constraint(equalTo: messageInputBar.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: messageInputBar.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputBar.topAnchor)
        ])
    }
    
    @objc private func handleSend() {
        guard let text = inputTextField.text, !text.isEmpty else { return }

        // Add new message to the thread
        if var chatThread = chatThread {
            let newMessage = ChatMessage(id: UUID().uuidString, sender: User(id: "currentUser", name: "Current User"), messageContent: text, timestamp: Date(), isSender: true)
            chatThread.messages.append(newMessage)
            
            self.chatThread = chatThread // Re-assign the modified chatThread back to the property

            inputTextField.text = nil

            // Reload data and ensure the table view updates before scrolling
            tableView.reloadData()

            DispatchQueue.main.async {
                let rowCount = self.chatThread?.messages.count ?? 0
                if rowCount > 0 {
                    let indexPath = IndexPath(row: rowCount - 1, section: 0)
                    if self.tableView.numberOfRows(inSection: 0) > indexPath.row {
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }
        }
    }

    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatThread?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        if let message = chatThread?.messages[indexPath.row] {
            cell.configure(with: message)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


