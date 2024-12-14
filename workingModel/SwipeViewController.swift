//
//  SwipeViewController.swift
//  ThriveUp
//
//  Created by palak seth on 17/11/24.
//
//
//  SwipeViewController.swift
//  ThriveUp
//
//  Created by palak seth on 17/11/24.
//
import UIKit

class SwipeViewController: UIViewController {
    
    private var eventStack: [Event] = EventDataSource.sampleEvents.reversed()
    private var bookmarkedEvents: [Event] = []
    
    private let cardContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let discardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        button.backgroundColor = .orange // Initial orange color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 35
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📖", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        button.backgroundColor = .orange // Initial orange color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 35
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Swipe Events"
        
        setupViews()
        setupConstraints()
        displayTopCards()
    }
    
    private func setupViews() {
        view.addSubview(cardContainerView)
        view.addSubview(discardButton)
        view.addSubview(bookmarkButton)
        
        discardButton.addTarget(self, action: #selector(handleDiscard), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(handleBookmark), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30), // Shift cards upward
            cardContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            cardContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6), // Reduce card height
            
            discardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            discardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            discardButton.widthAnchor.constraint(equalToConstant: 70),
            discardButton.heightAnchor.constraint(equalToConstant: 70),
            
            bookmarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            bookmarkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 70),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    private func displayTopCards() {
        cardContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        for (index, event) in eventStack.suffix(3).enumerated() {
            let cardView = createCard(for: event)
            cardContainerView.addSubview(cardView)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                cardView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: CGFloat(index) * 8),
                cardView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -CGFloat(index) * 8),
                cardView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: CGFloat(index) * 8),
                cardView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -CGFloat(index) * 8)
            ])
        }
    }
    
    private func createCard(for event: Event) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 15
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cardView.layer.shadowRadius = 10
        
        let imageView = UIImageView(image: event.image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = event.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20) // Reduced font size
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = event.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14) // Reduced font size
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(imageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        cardView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        cardView.addGestureRecognizer(swipeRight)
        
        return cardView
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard let cardView = gesture.view else { return }
        let direction = gesture.direction == .right ? 1 : -1
        
        UIView.animate(withDuration: 0.3, animations: {
            cardView.transform = CGAffineTransform(translationX: CGFloat(direction) * self.view.frame.width, y: 0)
            cardView.alpha = 0
        }, completion: { _ in
            cardView.removeFromSuperview()
            if gesture.direction == .right {
                self.bookmarkEvent()
            } else {
                self.discardEvent()
            }
        })
    }
    
    @objc private func handleDiscard() {
        discardEvent()
    }
    
    @objc private func handleBookmark() {
        bookmarkEvent()
    }
    
    private func discardEvent() {
        guard let _ = eventStack.last else { return }
        discardButton.backgroundColor = .red
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.discardButton.backgroundColor = .orange
        }
        
        eventStack.removeLast()
        displayTopCards()
    }
    
    private func bookmarkEvent() {
        guard let topEvent = eventStack.last else { return }
        bookmarkButton.backgroundColor = .green
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.bookmarkButton.backgroundColor = .orange
        }
        
        bookmarkedEvents.append(topEvent)
        saveBookmarks()
        eventStack.removeLast()
        displayTopCards()
    }
    
    private func saveBookmarks() {
        if let data = try? JSONEncoder().encode(bookmarkedEvents) {
            UserDefaults.standard.set(data, forKey: "bookmarkedEvents1")
        }
    }
}

