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
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup initial UI state
        initUI()
    }
        
    // MARK: - UI Configuration
        
    func initUI() {
        // Configure initial state of UI elements
        
        // Set up segmented control action
        sgmtEdit.addTarget(self, action: #selector(changeEditMode(_:)), for: .valueChanged)

        // Set up date button action
        dateButton.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside)
    }
        
    // MARK: - Actions
    @objc func changeEditMode(_ sender: UISegmentedControl) {
            // Handle segmented control value changed event
            
            switch sender.selectedSegmentIndex {
            case 0:
                // Editing mode off
                enableEditing(false)
            case 1:
                // Editing mode on
                enableEditing(true)
            default:
                break
            }
        }
        
        @objc func changeDate(_ sender: UIButton) {
            // Handle action when the date button is tapped
            // You can implement the logic to show a date picker or perform any other action related to changing the date
        }
        
        // MARK: - DateControllerDelegate
        
        func dateChanged(date: Date) {
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
    }
