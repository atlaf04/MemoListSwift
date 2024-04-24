//
//  SettingsViewController.swift
//  MemoProjectSwift
//
//  Created by Lexi Francis on 4/21/24.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pckSortField: UIPickerView!
    @IBOutlet weak var swAscending: UISwitch!
    @IBOutlet var settingsView: UIView!
<<<<<<< HEAD

=======
>>>>>>> 70e45525479a9c934d6e75a0c9ea624020c9b57d
    
    // Array of strings, type annotation, let declares constant, items in array are  initialization value this is what is in the sort order
    let sortOrderItems: Array<String> = ["subject", "date", "priority"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pckSortField.dataSource = self; //  By assigning self to the dataSource, you're indicating that the current view controller (SettingsViewController) will provide the necessary data for the UIPickerView.
        
        pckSortField.delegate = self; // responsible for handling user interactions and customizing the behavior of the UIPickerView
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func sortDirectionChanged(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
    }
    
 

    // MARK: UIPickerViewDelegate Methods
    
    // Returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the # of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }
    
    //Sets the value that is shown for each row in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
        -> String? {
            return sortOrderItems[row]
    }
    
    //If the user chooses from the pickerview, it calls this function;
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: Constants.kSortField)
        settings.synchronize()
    }
}
