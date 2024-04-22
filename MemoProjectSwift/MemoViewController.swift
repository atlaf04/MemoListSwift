//
//  MemoViewController.swift
//  MemoProjectSwift
//
//  Created by Lexi Francis on 4/21/24.
//

import UIKit

class MemoViewController: UIViewController {

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
            sgmtEdit.addTarget(self, action: #selector(editModeChanged(_:)), for: .valueChanged)
            
            // Set up date button action
            dateButton.addTarget(self, action: #selector(changeDate(_:)), for: .touchUpInside)
        }
        
        // MARK: - Actions
        
        @objc func editModeChanged(_ sender: UISegmentedControl) {
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
            // Handle date button tapped event
            // Implement your date change logic here
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
