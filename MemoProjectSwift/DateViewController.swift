//
//  DateViewController.swift
//  MemoProjectSwift
//
//  Created by Lexi Francis on 4/21/24.
//

import UIKit

protocol DateControllerDelegate: AnyObject { // Defining a protocol named DateControllerDelegate
    func dateChanged(date: Date) // Declaring a method to notify delegate when date changes
}

class DateViewController: UIViewController, DateControllerDelegate { // Creating a class named DateViewController which is a subclass of UIViewController and adopting DateControllerDelegate protocol
    
    func dateChanged(date: Date) { // Implementing the method to handle date changes
        
    }
    
    weak var delegate: DateControllerDelegate? // Declaring a weak delegate property of type DateControllerDelegate
    
    @IBOutlet weak var dtpDate: UIDatePicker! // Declaring an outlet for a date picker named dtpDate
    
    override func viewDidLoad() { // Overriding the viewDidLoad method
        super.viewDidLoad() // Calling the viewDidLoad method of the superclass
        
        let saveButton: UIBarButtonItem = // Creating a save button for navigation bar
        UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, // Setting the system item to save
                        target: self, // Setting the target to self
                        action: #selector(saveDate)) // Setting the action to saveDate method
        self.navigationItem.rightBarButtonItem = saveButton // Adding the save button to the navigation bar
        self.title = "Pick Date" // Setting the title of the view controller
    }
    
    @objc func saveDate(){ // Defining a method to save the selected date
        self.delegate?.dateChanged(date: dtpDate.date) // Notifying the delegate about the date change
        self.navigationController?.popViewController(animated: true) // Popping the view controller from the navigation stack
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "YourSegueIdentifier" { // Replace "YourSegueIdentifier" with the actual segue identifier
            if let destinationVC = segue.destination as? DateViewController {
                destinationVC.delegate = self // Assuming the main view controller adopts the DateControllerDelegate protocol
            }
        }
        
        
    }
}
// You now have a new file in your project DateViewController, which will be used to manage any actions on the Birthdate scene. This file will contain the DateControllerDelegate interface, as well as a reference to a delegate that it can use to specify the date that was picked.
// Switch to DateViewController.swift and add lines 3–5 in Listing 11.13.
          //This sets up the delegate protocol and specifies that any class adopting this protocol must also implement the dateChanged method. What the class chooses to have the dateChanged method do is up to the developer. In this case, the Date Controller calls this method on its delegate anytime the date changes. Note that the protocol uses the class keyword to specify that it only is available to be applied to classes—not to structs and enumerations.
    // For the subview to call back to the main view, it needs a reference to the main view. You do this by setting up a property that will have a reference to the main view. Add line 10 in Listing 11.13. The delegate property is of the same type as the protocol you just created. This will allow any kind of controller (or other object) to take advantage of the Date Controller to set a date. In some instances, a main controller may not set itself as a delegate of the Date Controller, so the delegate variable is set to weak and the type is optional, as specified by the question mark. See Appendix B for more on how to declare variables in Swift.





// Step 3: Specify That Main View Will Implement Delegate Protocol Switch to ContactsViewController.swift and specify that the class will conform to DateControllerDelegate by adding it to the list of interfaces in the class declaration:

// class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate
