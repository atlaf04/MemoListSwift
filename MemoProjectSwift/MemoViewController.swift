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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var sgmtEdit: UISegmentedControl!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtMemo: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet var settingsView: UIView!
    @IBOutlet var pSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup initial UI state
        initUI()
        
        // Enable or disable editing based on segmented control value
        enableEditing(sgmtEdit.selectedSegmentIndex == 1)
    }
    
    // MARK: - UI Configuration
    
    func initUI() {
        sgmtEdit.addTarget(self, action: #selector(changeEditMode(_:)), for: .valueChanged)
        dateButton.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside)
        pSegment.addTarget(self, action: #selector(prioritySegmentChanged(_:)), for: .valueChanged)
    }
    
    @objc func changeEditMode(_ sender: UISegmentedControl) {
        let textFields: [UITextField] = [txtMemo, txtSubject]
        
        if sgmtEdit.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = .none
            }
            dateButton.isHidden = true
            navigationItem.rightBarButtonItem = nil
        } else {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = .roundedRect
            }
            dateButton.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self,
                                                                action: #selector(saveMemo))
        }
        
        // Enable or disable editing based on segmented control value
        enableEditing(sgmtEdit.selectedSegmentIndex == 1)
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
    
    @objc func changeDate(_ sender: UIButton) {
        print("Change Date button pressed")
        // Instantiate the DateViewController from the storyboard
        guard let dateViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DateViewController") as? DateViewController else {
            return
        }
        
        // Set MemoViewController as the delegate of DateViewController
        dateViewController.delegate = self
        
        // Present the DateViewController
        navigationController?.pushViewController(dateViewController, animated: true)
    }
    
    func dateChanged(date: Date) {
        print("Date changed to: \(date)")
        // Update the label text with the selected date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        lblDate.text = formatter.string(from: date)
    }
    
    func enableEditing(_ enabled: Bool) {
        // Enable or disable editing for text fields and buttons
        txtSubject.isEnabled = enabled
        txtMemo.isEnabled = enabled
        dateButton.isEnabled = enabled
        pSegment.isEnabled = enabled
    }
    
    @objc func saveMemo() {
        let context = appDelegate.persistentContainer.viewContext
        
        if let memoText = txtMemo.text, let subject = txtSubject.text {
            if currentMemo == nil {
                currentMemo = Memo(context: context)
            }
            
            // Set memo properties
            currentMemo?.memo = memoText
            currentMemo?.subject = subject
            currentMemo?.date = Date() // Set the date to the current date
            
            // Set priority based on segmented control value
            switch pSegment.selectedSegmentIndex {
            case 0:
                currentMemo?.priority = 1 // Assuming 1 represents high priority
            case 1:
                currentMemo?.priority = 2 // Assuming 2 represents medium priority
            case 2:
                currentMemo?.priority = 3 // Assuming 3 represents low priority
            default:
                currentMemo?.priority = 0 // Set default priority or handle it according to your requirement
            }
            
            // Save changes
            do {
                try context.save()
            } catch {
                print("Error saving memo: \(error.localizedDescription)")
            }
        }
    }
    @IBAction func prioritySegmentChanged(_ sender: UISegmentedControl) {
        guard let currentMemo = currentMemo else {
            return
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            currentMemo.priority = 1 // Assuming 1 represents high priority
        case 1:
            currentMemo.priority = 2 // Assuming 2 represents medium priority
        case 2:
            currentMemo.priority = 3 // Assuming 3 represents low priority
        default:
            currentMemo.priority = 0 // Set default priority or handle it according to your requirement
        }
    }
}


