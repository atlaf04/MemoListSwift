//
//  MemoViewController.swift
//  MemoProjectSwift
//
//  Created by Lexi Francis on 4/21/24.
//

import UIKit // Importing UIKit framework for UI components
import CoreData // Importing CoreData framework for data management

class MemoViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UINavigationControllerDelegate { // Creating a class named MemoViewController which is a subclass of UIViewController and adopting protocols UITextFieldDelegate, DateControllerDelegate, UINavigationControllerDelegate
    
    var currentMemo: Memo? // Declaring a variable named currentMemo of type Memo (a Core Data entity)
    var selectedDate: Date? // Declaring a variable named selectedDate of type Date
    let appDelegate = UIApplication.shared.delegate as! AppDelegate // Accessing the shared app instance and casting its delegate as AppDelegate
    
    @IBOutlet weak var sgmtEdit: UISegmentedControl! // Declaring an outlet for a segmented control named sgmtEdit
    @IBOutlet weak var txtSubject: UITextField! // Declaring an outlet for a text field named txtSubject
    @IBOutlet weak var txtMemo: UITextField! // Declaring an outlet for a text field named txtMemo
    @IBOutlet weak var dateButton: UIButton! // Declaring an outlet for a button named dateButton
    @IBOutlet weak var lblDate: UILabel! // Declaring an outlet for a label named lblDate
    @IBOutlet var settingsView: UIView! // Declaring an outlet for a view named settingsView
    @IBOutlet var pSegment: UISegmentedControl! // Declaring an outlet for a segmented control named pSegment
    
    override func viewDidLoad() { // Overriding the viewDidLoad method
        super.viewDidLoad() // Calling the viewDidLoad method of the superclass
        initUI() // Calling the method to initialize the UI
        enableEditing(sgmtEdit.selectedSegmentIndex == 1) // Enabling or disabling editing based on the initial state of sgmtEdit
        populateUIWithMemoDetails() // Populating the UI with memo details
    }
    
    // MARK: - UI Configuration
    
    func initUI() { // Defining a method to initialize the UI
        sgmtEdit.addTarget(self, action: #selector(changeEditMode(_:)), for: .valueChanged) // Adding a target-action pair to sgmtEdit for valueChanged event
        dateButton.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside) // Adding a target-action pair to dateButton for touchUpInside event
        pSegment.addTarget(self, action: #selector(prioritySegmentChanged(_:)), for: .valueChanged) // Adding a target-action pair to pSegment for valueChanged event
    }
    
    @objc func changeEditMode(_ sender: UISegmentedControl) { // Defining a method to handle changes in edit mode
        let textFields: [UITextField] = [txtMemo, txtSubject] // Creating an array of text fields
        
        if sgmtEdit.selectedSegmentIndex == 0 { // Checking if the "Edit" segment is selected
            for textField in textFields { // Looping through the text fields
                textField.isEnabled = false // Disabling text field
                textField.borderStyle = .none // Setting border style to none
            }
            dateButton.isHidden = true // Hiding the date button
            navigationItem.rightBarButtonItem = nil // Removing the right bar button item
        } else { // If "Done" segment is selected
            for textField in textFields { // Looping through the text fields
                textField.isEnabled = true // Enabling text field
                textField.borderStyle = .roundedRect // Setting border style to rounded rect
            }
            dateButton.isHidden = false // Showing the date button
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveMemo)) // Adding a save button to the navigation bar
        }
        enableEditing(sgmtEdit.selectedSegmentIndex == 1) // Enabling or disabling editing based on the selected segment
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { // Defining a method to handle ending editing in text fields
        if currentMemo == nil { // Checking if currentMemo is nil
            let context = appDelegate.persistentContainer.viewContext // Accessing the Core Data managed object context
            currentMemo = Memo(context: context) // Creating a new Memo object
        }
        currentMemo?.memo = txtMemo.text // Setting memo text
        currentMemo?.subject = txtSubject.text // Setting memo subject
        return true // Returning true to allow text field to end editing
    }
    
    @objc func changeDate(_ sender: UIButton) { // Defining a method to handle changing the date
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Accessing the storyboard
        guard let dateViewController = storyboard.instantiateViewController(withIdentifier: "DateViewController") as? DateViewController else { // Instantiating DateViewController from storyboard
            return // Exiting if instantiation fails
        }
        dateViewController.delegate = self // Setting the delegate
        navigationController?.pushViewController(dateViewController, animated: true) // Pushing the DateViewController onto the navigation
    }
    
    func dateChanged(date: Date) { // Defining a method to handle date changes
        selectedDate = date // Setting the selected date
        let formatter = DateFormatter() // Creating a date formatter
        formatter.dateStyle = .short // Setting the date style
        lblDate.text = formatter.string(from: date) // Setting the label text to formatted date
    }
    
    func enableEditing(_ enabled: Bool) { // Defining a method to enable or disable editing
        txtSubject.isEnabled = enabled // Enabling or disabling subject text field
        txtMemo.isEnabled = enabled // Enabling or disabling memo text field
        dateButton.isEnabled = enabled // Enabling or disabling date button
        pSegment.isEnabled = enabled // Enabling or disabling priority segment control
    }
    
    @objc func saveMemo() { // Defining a method to save the memo
        let context = appDelegate.persistentContainer.viewContext // Accessing the Core Data managed object context
        
        guard let memoText = txtMemo.text, let subject = txtSubject.text else { // Checking if memo text and subject are not nil
            return // Exiting if either is nil
        }
        
        if currentMemo == nil { // Checking if currentMemo is nil
            currentMemo = Memo(context: context) // Creating a new Memo object
        }
        
        currentMemo?.memo = memoText // Setting memo text
        currentMemo?.subject = subject // Setting memo subject
        currentMemo?.date = selectedDate // Setting memo date
        
        // No need to set priority here
        
        do { // Starting a do-catch block for error handling
            try context.save() // Saving changes to Core Data
            if let memoTableViewController = navigationController?.viewControllers.first as? MemoTableViewController { // Accessing MemoTableViewController
                memoTableViewController.loadDataFromDatabase() // Loading data from database
                memoTableViewController.tableView.reloadData() // Reloading table view data
            }
        } catch { // Catching any errors
            print("Error saving memo: \(error.localizedDescription)") // Printing error message
        }
    }
    
    @IBAction func prioritySegmentChanged(_ sender: UISegmentedControl) { // Defining a method to handle priority segment changes
        guard let currentMemo = currentMemo else { // Checking if currentMemo is not nil
            return // Exiting if currentMemo is nil
        }
        
        switch sender.selectedSegmentIndex { // Checking the selected segment index of a segmented control
            
            case 0: // If the index is 0
                currentMemo.priority = 1 // Setting the priority of the current memo to 1 (high priority)
                
            case 1: // If the index is 1
                currentMemo.priority = 2 // Setting the priority of the current memo to 2 (medium priority)
                
            case 2: // If the index is 2
                currentMemo.priority = 3 // Setting the priority of the current memo to 3 (low priority)
                
            default: // If none of the above cases match
                currentMemo.priority = 0 // Setting the priority of the current memo to 0 as a default value
        }
    }
    
    func populateUIWithMemoDetails() {
        guard let memo = currentMemo else {// Checking if there's a current memo to populate UI with
            return// Exiting the function if there's no current memo
        }
        
        txtSubject.text = memo.subject // Setting the subject text field with memo's subject
        txtMemo.text = memo.memo // Setting the memo text field with memo's text
        
        if let date = memo.date { // Checking if memo has a date
                let formatter = DateFormatter() // Creating a date formatter
                formatter.dateStyle = .short // Setting the date style to short
                lblDate.text = formatter.string(from: date) // Setting label text to formatted date
            }
        
        // Set the selected segment based on the memo's priority
        switch memo.priority {
        case 1: // If priority is 1
                    pSegment.selectedSegmentIndex = 0 // Selecting the high priority segment
                    
                case 2: // If priority is 2
                    pSegment.selectedSegmentIndex = 1 // Selecting the medium priority segment
                    
                case 3: // If priority is 3
                    pSegment.selectedSegmentIndex = 2 // Selecting the low priority segment
                    
                default: // If the priority is anything else (including 0 or unexpected values)
                    pSegment.selectedSegmentIndex = UISegmentedControl.noSegment // Deselecting all segments in the segmented control
            }
    }
}
