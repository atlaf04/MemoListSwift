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
    var selectedDate: Date?
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
        initUI()
        enableEditing(sgmtEdit.selectedSegmentIndex == 1)
        populateUIWithMemoDetails()
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let dateViewController = storyboard.instantiateViewController(withIdentifier: "DateViewController") as? DateViewController else {
            return
        }
        dateViewController.delegate = self
        navigationController?.pushViewController(dateViewController, animated: true)
    }
    
    func dateChanged(date: Date) {
        selectedDate = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        lblDate.text = formatter.string(from: date)
    }
    
    func enableEditing(_ enabled: Bool) {
        txtSubject.isEnabled = enabled
        txtMemo.isEnabled = enabled
        dateButton.isEnabled = enabled
        pSegment.isEnabled = enabled
    }
    
    @objc func saveMemo() {
        let context = appDelegate.persistentContainer.viewContext
        
        guard let memoText = txtMemo.text, let subject = txtSubject.text else {
            return
        }
        
        if currentMemo == nil {
            currentMemo = Memo(context: context)
        }
        
        currentMemo?.memo = memoText
        currentMemo?.subject = subject
        currentMemo?.date = selectedDate
        
        // No need to set priority here
        
        do {
            try context.save()
            if let memoTableViewController = navigationController?.viewControllers.first as? MemoTableViewController {
                memoTableViewController.loadDataFromDatabase()
                memoTableViewController.tableView.reloadData()
            }
        } catch {
            print("Error saving memo: \(error.localizedDescription)")
        }
    }
    
    @IBAction func prioritySegmentChanged(_ sender: UISegmentedControl) {
        guard let currentMemo = currentMemo else {
            return
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            currentMemo.priority = 1
        case 1:
            currentMemo.priority = 2
        case 2:
            currentMemo.priority = 3
        default:
            currentMemo.priority = 0
        }
    }
    
    func populateUIWithMemoDetails() {
        guard let memo = currentMemo else {
            return
        }
        
        txtSubject.text = memo.subject
        txtMemo.text = memo.memo
        
        if let date = memo.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            lblDate.text = formatter.string(from: date)
        }
        
        // Set the selected segment based on the memo's priority
        switch memo.priority {
        case 1:
            pSegment.selectedSegmentIndex = 0 // High Priority
        case 2:
            pSegment.selectedSegmentIndex = 1 // Medium Priority
        case 3:
            pSegment.selectedSegmentIndex = 2 // Low Priority
        default:
            pSegment.selectedSegmentIndex = UISegmentedControl.noSegment
        }
    }
}
