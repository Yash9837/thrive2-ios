//
//  RegisteredEventCell.swift
//  ThriveUp
//
//  Created by Yash's Mackbook on 17/11/24.
//

import UIKit

class RegisteredEventCell: UITableViewCell {

        
        static let identifier = "RegisteredEventCell"

        // MARK: - UI Elements
        private let eventImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            return imageView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.numberOfLines = 1
            return label
        }()
        
        private let dateLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .gray
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
            contentView.addSubview(eventImageView)
            contentView.addSubview(titleLabel)
            contentView.addSubview(dateLabel)
            
            eventImageView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                // Event Image
                eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                eventImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                eventImageView.widthAnchor.constraint(equalToConstant: 60),
                eventImageView.heightAnchor.constraint(equalToConstant: 60),
                
                // Title Label
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Date Label
                dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                dateLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 16),
                dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ])
        }

        // MARK: - Configure Cell
        func configure(with event: EventModel) {
            titleLabel.text = event.title
            dateLabel.text = "\(event.date), \(event.time)"
            eventImageView.image = UIImage(named: event.imageName) // Ensure valid imageName
        }
    }

