//
//  NotificationCell.swift
//  ThriveUp
//
//  Created by palak seth on 15/11/24.
//

import UIKit

class NotificationCell: UITableViewCell {
    static let identifier = "NotificationCell"

    private let userImageView = UIImageView()
    private let messageLabel = UILabel()
    private let timestampLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Configure image view
        userImageView.layer.cornerRadius = 25
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleAspectFill
        contentView.addSubview(userImageView)

        // Configure message label
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(messageLabel)

        // Configure timestamp label
        timestampLabel.font = UIFont.systemFont(ofSize: 12)
        timestampLabel.textColor = .systemOrange
        timestampLabel.textAlignment = .right
        contentView.addSubview(timestampLabel)

        // Layout constraints
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Image view constraints
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50),

            // Timestamp label constraints (aligned to the right)
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timestampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            // Message label constraints
            messageLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: timestampLabel.leadingAnchor, constant: -8),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with notification: NotificationItem) {
        userImageView.image = notification.userImage
        messageLabel.text = notification.message
        timestampLabel.text = notification.timestamp
    }
}

