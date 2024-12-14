//
//  RegistrationViewController.swift
//  ThriveUp
//
//  Created by Yash's Mackbook on 14/11/24.
//

import UIKit

class RegistrationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    
    private let tableView = UITableView()
    private var formFields: [FormField]
    private var eventId: String
    // Use the formFields array from DataModel
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var event: EventModel // Store the event model

    
    init(formFields: [FormField], event: EventModel) {
        self.formFields = formFields
        self.event = event // Assign the full event
        self.eventId = event.eventId // Extract the eventId for backward compatibility
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Registration"
        
        // Configure the table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FormFieldTableViewCell.self, forCellReuseIdentifier: "FormFieldTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Add the submit button and configure its action
        view.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        // Set up constraints for the table view and the submit button
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -16),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormFieldTableViewCell", for: indexPath) as! FormFieldTableViewCell
        let field = formFields[indexPath.row]
        cell.configure(with: field.placeholder, value: field.value)
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        return cell
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        formFields[textField.tag].value = textField.text ?? ""
    }
    
    // MARK: - Handle Submit
    
    
    
    @objc private func handleSubmit() {
        saveRegistrationDataToFile(event: event) // Save the full event model

        let alert = UIAlertController(title: "Success", message: "Registration successful!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }



    private func saveRegistrationDataToFile(event: EventModel) {
        let fileURL: URL
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            fileURL = documentsDirectory.appendingPathComponent("RegisteredEvent.json")
            print("Saving data for event: \(event.eventId)")
        } else {
            print("Error accessing documents directory.")
            return
        }

        var savedEvents: [EventModel] = []
        
        // Load existing data from the file if it exists
        if let existingData = try? Data(contentsOf: fileURL),
           let existingEvents = try? JSONDecoder().decode([EventModel].self, from: existingData) {
            savedEvents = existingEvents
        }

        // Add the new event if it’s not already in the list
        if !savedEvents.contains(where: { $0.eventId == event.eventId }) {
            savedEvents.append(event)
        }

        do {
            // Convert the updated events array to JSON data
            let jsonData = try JSONEncoder().encode(savedEvents)
            try jsonData.write(to: fileURL)
            print("Data successfully saved to \(fileURL)")
        } catch {
            print("Error saving data: \(error)")
        }
    }





}
