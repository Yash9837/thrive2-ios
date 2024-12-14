//
//  ChatCell.swift
//  ThriveUp
//
//  Created by palak seth on 13/11/24.
//

import UIKit

class ChatCell: UITableViewCell {
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let messageLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupCell()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setupCell() {
            // Profile Image
            profileImageView.layer.cornerRadius = 30
            profileImageView.clipsToBounds = true
            contentView.addSubview(profileImageView)
            
            // Name Label
            nameLabel.font = .boldSystemFont(ofSize: 20)
            contentView.addSubview(nameLabel)
            
            // Message Label
            messageLabel.font = .systemFont(ofSize: 16)
            messageLabel.textColor = .gray
            contentView.addSubview(messageLabel)
            
            // Time Label
            timeLabel.font = .systemFont(ofSize: 14)
            timeLabel.textColor = .lightGray
            contentView.addSubview(timeLabel)
            
            // Layout Constraints
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            timeLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                profileImageView.widthAnchor.constraint(equalToConstant: 50),
                profileImageView.heightAnchor.constraint(equalToConstant: 50),
                
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
                
                messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
                messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                messageLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
                
                timeLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        }

        func configure(with name: String, message: String, time: String, profileImage: UIImage?) {
            nameLabel.text = name
            messageLabel.text = message
            timeLabel.text = time
            profileImageView.image = profileImage
        }

}

