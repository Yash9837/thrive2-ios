//
//  EventPostViewController.swift
//  ThriveUp
//
//  Created by Yash's Mackbook on 14/12/24.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth

class EventPostViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let titleTextField = UITextField()
    
    private let categoryLabel = UILabel()
    private let categoryTextField = UITextField()
    private let categoryPicker = UIPickerView()
    
    private let attendanceLabel = UILabel()
    private let attendanceTextField = UITextField()
    
    private let organizerLabel = UILabel()
    private let organizerTextField = UITextField()
    
    private let dateLabel = UILabel()
    private let datePicker = UIDatePicker()
    
    private let timeLabel = UILabel()
    private let timeTextField = UITextField()
    
    private let locationLabel = UILabel()
    private let locationTextField = UITextField()
    
    private let locationDetailsLabel = UILabel()
    private let locationDetailsTextField = UITextField()
    
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    private let imageLabel = UILabel()
    private let imageTextField = UITextField()
    
    private let latitudeLabel = UILabel()
    private let latitudeTextField = UITextField()
    
    private let longitudeLabel = UILabel()
    private let longitudeTextField = UITextField()
    
    private let submitButton = UIButton(type: .system)
    
    // Firestore Reference
    private let db = Firestore.firestore()
    
    // Predefined Categories
    private let categories = [
        "Trending", "Fun and Entertainment", "Tech and Innovation",
        "Club and Societies", "Cultural", "Networking", "Sports",
        "Career Connect", "Wellness", "Other"
    ]
    private var selectedCategory: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupKeyboardHandling()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "Post an Event"
        
        // Scroll View
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Title
        titleLabel.text = "Event Title"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(titleLabel)
        setupTextField(titleTextField, placeholder: "Enter event title")
        
        // Category
        categoryLabel.text = "Category"
        categoryLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(categoryLabel)
        setupTextField(categoryTextField, placeholder: "Select category")
        categoryTextField.inputView = categoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        // Attendance
        attendanceLabel.text = "Attendance Count"
        attendanceLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(attendanceLabel)
        setupTextField(attendanceTextField, placeholder: "Enter attendance count", keyboardType: .numberPad)
        
        // Organizer
        organizerLabel.text = "Organizer Name"
        organizerLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(organizerLabel)
        setupTextField(organizerTextField, placeholder: "Enter organizer name")
        
        // Date Picker
        dateLabel.text = "Event Date"
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(dateLabel)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        contentView.addSubview(datePicker)
        
        // Time
        timeLabel.text = "Event Time"
        timeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(timeLabel)
        setupTextField(timeTextField, placeholder: "Enter event time (e.g., 10:00 AM)")
        
        // Location
        locationLabel.text = "Location"
        locationLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(locationLabel)
        setupTextField(locationTextField, placeholder: "Enter location")
        
        // Location Details
        locationDetailsLabel.text = "Location Details"
        locationDetailsLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(locationDetailsLabel)
        setupTextField(locationDetailsTextField, placeholder: "Enter location details")
        
        // Description
        descriptionLabel.text = "Event Description"
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(descriptionLabel)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.font = .systemFont(ofSize: 14)
        contentView.addSubview(descriptionTextView)
        
        // Image Name/URL
        imageLabel.text = "Image URL"
        imageLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(imageLabel)
        setupTextField(imageTextField, placeholder: "Enter image URL")
        
        // Latitude
        latitudeLabel.text = "Latitude"
        latitudeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(latitudeLabel)
        setupTextField(latitudeTextField, placeholder: "Enter latitude", keyboardType: .decimalPad)
        
        // Longitude
        longitudeLabel.text = "Longitude"
        longitudeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(longitudeLabel)
        setupTextField(longitudeTextField, placeholder: "Enter longitude", keyboardType: .decimalPad)
        
        // Submit Button
        submitButton.setTitle("Post Event", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.addTarget(self, action: #selector(postEvent), for: .touchUpInside)
        contentView.addSubview(submitButton)
    }
    
    private func setupConstraints() {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            let views: [UIView] = [
                titleLabel, titleTextField,
                categoryLabel, categoryTextField,
                attendanceLabel, attendanceTextField,
                organizerLabel, organizerTextField,
                dateLabel, datePicker,
                timeLabel, timeTextField,
                locationLabel, locationTextField,
                locationDetailsLabel, locationDetailsTextField,
                descriptionLabel, descriptionTextView,
                imageLabel, imageTextField,
                latitudeLabel, latitudeTextField,
                longitudeLabel, longitudeTextField,
                submitButton
            ]
            
            for view in views {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
            
            NSLayoutConstraint.activate([
                // ScrollView Constraints
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                // ContentView Constraints
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                // Title Label
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Title TextField
                titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                titleTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Category Label
                categoryLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
                categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Category TextField
                categoryTextField.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
                categoryTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                categoryTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                categoryTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Attendance Label
                attendanceLabel.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 16),
                attendanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                attendanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Attendance TextField
                attendanceTextField.topAnchor.constraint(equalTo: attendanceLabel.bottomAnchor, constant: 8),
                attendanceTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                attendanceTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                attendanceTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Organizer Label
                organizerLabel.topAnchor.constraint(equalTo: attendanceTextField.bottomAnchor, constant: 16),
                organizerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                organizerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Organizer TextField
                organizerTextField.topAnchor.constraint(equalTo: organizerLabel.bottomAnchor, constant: 8),
                organizerTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                organizerTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                organizerTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Date Label
                dateLabel.topAnchor.constraint(equalTo: organizerTextField.bottomAnchor, constant: 16),
                dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Date Picker
                datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
                datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Time Label
                timeLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16),
                timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Time TextField
                timeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
                timeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                timeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                timeTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Location Label
                locationLabel.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 16),
                locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Location TextField
                locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
                locationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                locationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                locationTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Location Details Label
                locationDetailsLabel.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 16),
                locationDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                locationDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Location Details TextField
                locationDetailsTextField.topAnchor.constraint(equalTo: locationDetailsLabel.bottomAnchor, constant: 8),
                locationDetailsTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                locationDetailsTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                locationDetailsTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Description Label
                descriptionLabel.topAnchor.constraint(equalTo: locationDetailsTextField.bottomAnchor, constant: 16),
                descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Description TextView
                descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
                descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
                
                // Image Label
                imageLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
                imageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                imageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Image TextField
                imageTextField.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: 8),
                imageTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                imageTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                imageTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Latitude Label
                latitudeLabel.topAnchor.constraint(equalTo: imageTextField.bottomAnchor, constant: 16),
                latitudeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                latitudeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Latitude TextField
                latitudeTextField.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 8),
                latitudeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                latitudeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                latitudeTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Longitude Label
                longitudeLabel.topAnchor.constraint(equalTo: latitudeTextField.bottomAnchor, constant: 16),
                longitudeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                longitudeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                // Longitude TextField
                longitudeTextField.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 8),
                longitudeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                longitudeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                longitudeTextField.heightAnchor.constraint(equalToConstant: 44),
                
                // Submit Button
                submitButton.topAnchor.constraint(equalTo: longitudeTextField.bottomAnchor, constant: 20),
                submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                submitButton.heightAnchor.constraint(equalToConstant: 50),
                submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        }

    private func setupTextField(_ textField: UITextField, placeholder: String, keyboardType: UIKeyboardType = .default) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        contentView.addSubview(textField)
    }
    
    // MARK: - Post Event
    @objc private func postEvent() {
        // Validate input fields
        guard let title = titleTextField.text, !title.isEmpty,
              let selectedCategory = selectedCategory, !selectedCategory.isEmpty,
              let organizerName = organizerTextField.text, !organizerName.isEmpty,
              let time = timeTextField.text, !time.isEmpty,
              let location = locationTextField.text, !location.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all required fields.")
            return
        }
        
        // Ensure user is authenticated
        guard let currentUser = Auth.auth().currentUser else {
            showAlert(title: "Error", message: "You must be logged in to post an event.")
            return
        }
        
        // Generate event data
        let eventId = UUID().uuidString
        let attendanceCount = Int(attendanceTextField.text ?? "0") ?? 0
        let eventDate = DateFormatter.localizedString(from: datePicker.date, dateStyle: .medium, timeStyle: .none)
        let locationDetails = locationDetailsTextField.text ?? ""
        let description = descriptionTextView.text.isEmpty ? nil : descriptionTextView.text
        let imageName = imageTextField.text ?? ""
        let latitude = Double(latitudeTextField.text ?? "0.0")
        let longitude = Double(longitudeTextField.text ?? "0.0")
        
        let eventData: [String: Any] = [
            "eventId": eventId,
            "title": title,
            "category": selectedCategory,
            "attendanceCount": attendanceCount,
            "organizerName": organizerName,
            "date": eventDate,
            "time": time,
            "location": location,
            "locationDetails": locationDetails,
            "description": description ?? "",
            "imageName": imageName,
            "latitude": latitude ?? 0.0,
            "longitude": longitude ?? 0.0,
            "uid": currentUser.uid // Add user ID
        ]
        
        db.collection("events").document(eventId).setData(eventData) { error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Success", message: "Event posted successfully!")
            }
        }
    }
    
    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UIPickerViewDelegate and UIPickerViewDataSource
extension EventPostViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        categoryTextField.text = selectedCategory
    }
}
