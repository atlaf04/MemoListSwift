//
//  MemoViewController.swift
//  MemoProjectSwift
//
//  Created by Lexi Francis on 4/21/24.
//

import UIKit
import CoreData

class MemoViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UINavigationControllerDelegate {
    
    var currentMemo: Memo?
    var selectedPriority: Int = 0 // Default priority
        
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var sgmtEdit: UISegmentedControl!

    @IBOutlet weak var txtSubject: UITextField!
    
    
    @IBOutlet weak var txtMemo: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet var settingsView: UIView!

    //@IBOutlet weak var settingsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup initial UI state
        initUI()
    }
        
    // MARK: - UI Configuration
        
    func initUI() {
            sgmtEdit.addTarget(self, action: #selector(changeEditMode(_:)), for: .valueChanged)
            dateButton.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside)
        
            lowButton.tag = 1
            mediumButton.tag = 2 // Assign tags to buttons to identify priorities
            highButton.tag = 3
            mediumButton.addTarget(self, action: #selector(priorityButtonTapped(_:)), for: .touchUpInside)
            lowButton.addTarget(self, action: #selector(priorityButtonTapped(_:)), for: .touchUpInside)
            highButton.addTarget(self, action: #selector(priorityButtonTapped(_:)), for: .touchUpInside)
        }
    
    @objc func priorityButtonTapped(_ sender: UIButton) {
            // Handle priority button taps
        selectedPriority = sender.tag // Set selected priority based on button tag
        switch sender {
            case lowButton:
                selectedPriority = 1
            case mediumButton:
                selectedPriority = 2
            case highButton:
                selectedPriority = 3
            default:
                break
            }
        
        }
    
    // MARK: - Actions
    @objc func changeEditMode(_ sender: UISegmentedControl) {
        let textFields: [UITextField] = [txtMemo, txtSubject]
        if sgmtEdit.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            dateButton.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmtEdit.selectedSegmentIndex == 1{
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            dateButton.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self,
                                                                action: #selector(self.saveMemo))
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if currentMemo == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentMemo = Memo(context: context)
        }
        currentMemo?.memo = txtMemo.text
        currentMemo?.subject = txtSubject.text
        return true
    }
    
    @objc func changeDate(_ sender: UIButton) { // button
        // Show a date picker to choose a new date
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        // Check if the currentMemo has a date set, if so, set the date picker to that date
        if let currentDate = currentMemo?.date {
            datePicker.date = currentDate
        }
        
        // Create an alert controller with a date picker
        let alertController = UIAlertController(title: "Select Date", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(datePicker)
        
        // Add actions to the alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            // Update the currentMemo's date with the selected date
            self.currentMemo?.date = datePicker.date
            
            // Update the date label with the selected date
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            self.lblDate.text = formatter.string(from: datePicker.date)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
        
        // MARK: - DateControllerDelegate
        
    func dateChanged(date: Date) { // updates the label
            if currentMemo == nil {
                let context = appDelegate.persistentContainer.viewContext
                currentMemo = Memo(context: context)
            }
            currentMemo?.date = date
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            lblDate.text = formatter.string(from: date)
        }
        
        // MARK: - Helper Methods
        
        func enableEditing(_ enabled: Bool) {
            // Enable or disable editing for text fields and buttons
            
            txtSubject.isEnabled = enabled
            txtMemo.isEnabled = enabled
            dateButton.isEnabled = enabled
            mediumButton.isEnabled = enabled
            lowButton.isEnabled = enabled
            highButton.isEnabled = enabled
            
            // Additional UI updates as needed
        }
    
    @objc func saveMemo() {
        let context = appDelegate.persistentContainer.viewContext
        
        if let memoText = txtMemo.text, let subject = txtSubject.text {
            if currentMemo == nil {
                currentMemo = Memo(context: context)
            }
            
            currentMemo?.priority = Int32((selectedPriority)) // Ensure priority is stored as Int32 --> dependent on size
            currentMemo?.memo = memoText
            currentMemo?.subject = subject
            currentMemo?.date = Date() // Set the date to the current date
            
            do {
                try context.save()
            } catch {
                print("Error saving memo: \(error.localizedDescription)")
            }
        }
    }
    }
