//
//  DateViewController.swift
//  MemoProjectSwift
//
//  Created by Lexi Francis on 4/21/24.
//

import UIKit

protocol DateControllerDelegate: AnyObject {
    func dateChanged(date: Date)
}

class DateViewController: UIViewController {
    
    weak var delegate: DateControllerDelegate?
    
    @IBOutlet weak var dtpDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let saveButton: UIBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save,
                            target: self,
                            action: #selector(saveDate))
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick Date"
    }
    
    @objc func saveDate(){ 
        self.delegate?.dateChanged(date: dtpDate.date)
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// You now have a new file in your project DateViewController, which will be used to manage any actions on the Birthdate scene. This file will contain the DateControllerDelegate interface, as well as a reference to a delegate that it can use to specify the date that was picked.
// Switch to DateViewController.swift and add lines 3–5 in Listing 11.13.
          //This sets up the delegate protocol and specifies that any class adopting this protocol must also implement the dateChanged method. What the class chooses to have the dateChanged method do is up to the developer. In this case, the Date Controller calls this method on its delegate anytime the date changes. Note that the protocol uses the class keyword to specify that it only is available to be applied to classes—not to structs and enumerations.
    // For the subview to call back to the main view, it needs a reference to the main view. You do this by setting up a property that will have a reference to the main view. Add line 10 in Listing 11.13. The delegate property is of the same type as the protocol you just created. This will allow any kind of controller (or other object) to take advantage of the Date Controller to set a date. In some instances, a main controller may not set itself as a delegate of the Date Controller, so the delegate variable is set to weak and the type is optional, as specified by the question mark. See Appendix B for more on how to declare variables in Swift.





// Step 3: Specify That Main View Will Implement Delegate Protocol Switch to ContactsViewController.swift and specify that the class will conform to DateControllerDelegate by adding it to the list of interfaces in the class declaration:

// class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate {


