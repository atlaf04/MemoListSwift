//
//  MemoTableViewController.swift
//  MemoProjectSwift
//
//  Created by Lexi Francis on 4/20/24.
//


import UIKit
import CoreData

class MemoTableViewController: UITableViewController {
    
    var memos: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadDataFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
    }
    
    func loadDataFromDatabase() { // Defining a method to load data from the database
            let settings = UserDefaults.standard // Accessing UserDefaults
            let sortField = settings.string(forKey: Constants.kSortField) // Getting the sort field from UserDefaults
            let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending) // Getting the sort direction from UserDefaults
            
            // Set up Core Data Context
            let context = appDelegate.persistentContainer.viewContext // Accessing the Core Data managed object context
            
            // Create fetch request
            let request: NSFetchRequest<Memo> = Memo.fetchRequest() // Creating a fetch request for Memo objects
            
            // Set sort descriptors
            if let sortField = sortField { // Checking if sortField exists
                if sortField == "priority" { // If sorting by priority
                    request.sortDescriptors = [NSSortDescriptor(key: sortField, ascending: sortAscending),
                                               NSSortDescriptor(key: "date", ascending: true)] // Sorting by priority and then by date
                } else {
                    request.sortDescriptors = [NSSortDescriptor(key: sortField, ascending: sortAscending)] // Sorting by other fields
                }
            }
        
        do { // Starting a do-catch block for error handling
                    memos = try context.fetch(request) // Fetching memos from Core Data
                } catch let error as NSError { // Catching any errors
                    print("Could not fetch. \(error), \(error.userInfo)") // Printing error message
                }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int { // Overriding the method to return the number of sections in the table view
        return 1//returning one section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {// Overriding the method to return the number of rows in the section
        return memos.count // Returning the number of memos
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemosCell", for: indexPath)

        // Configure cell
               let memo = memos[indexPath.row] as? Memo // Getting the memo object for the current row
               cell.textLabel?.text = memo?.subject // Setting the cell's text label to memo's subject
               let tdate = formatDateShort(memo?.date) // Formatting memo's date
               let plevel = memo?.priority // Getting memo's priority level
               var txtpriority: String // Declaring a variable to hold priority text
               
               if let plevel = plevel { // Checking if priority level exists
                   switch plevel { // Switching on priority level
                       
                       case 1: // If priority is 1
                           txtpriority = "Low Priority" // Setting priority text to "Low Priority"
                           
                       case 2: // If priority is 2
                           txtpriority = "Medium Priority" // Setting priority text to "Medium Priority"
                           
                       case 3: // If priority is 3
                           txtpriority = "High Priority" // Setting priority text to "High Priority"
                           
                       default: // Handling default case
                           txtpriority = "Unknown" // Setting priority text to "Unknown"
                   }
        } else {
            txtpriority = "Unknown"
        }
        cell.detailTextLabel?.text = tdate + " " + txtpriority
        cell.accessoryType = .detailDisclosureButton

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = memos[indexPath.row] as? Memo
        // getting the contact object associated with the selected row
        let memo = selectedMemo!.subject!
        let actionHandler = { (action:UIAlertAction!) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // gets a reference to the storyboard named Main
            let controller = storyboard.instantiateViewController(withIdentifier: "MemoViewController")// instantiates an instance of the view controller using an identifier.
            as? MemoViewController
            controller?.currentMemo = selectedMemo // Pass the selected memo to MemoViewController
            self.navigationController?.pushViewController(controller!, animated: true)
            
            //  navigation controller used to push the view controller onto the navigation stack. ensuring the controller has the Back button functionality
        }
        
        let alertController = UIAlertController(title: "Memo selected",
                                                message:  "Selected row: \(indexPath.row) (\(memo))",
            preferredStyle: .alert)
        // UIAlertController with a title and message, can either be .alert (which we are using) or .actionsheet. The action sheet is used when more than two or three options are needed, as it stacks the buttons on top of each other.
        
        let actionCancel = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil) // add the two buttons to the Alert Controller, and line 20 displays the controller.
        let actionDetails = UIAlertAction(title: "Show Details",
                                          style: .default,
                                          handler: actionHandler)
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        present(alertController, animated: true, completion: nil)
    }
//
//        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let selectedMemo = memos[indexPath.row] as? Memo
//            // getting the contact object associated with the selected row
//            let memo = selectedMemo!.subject!
//            let actionHandler = { (action:UIAlertAction!) -> Void in
//                let storyboard = UIStoryboard(name: "Main", bundle: nil) // gets a reference to the storyboard named Main
//                let controller = storyboard.instantiateViewController(withIdentifier: "MemoViewController")// instantiates an instance of the view controller using an identifier.
//                as? MemoViewController
//                controller?.currentMemo = selectedMemo
//                self.navigationController?.pushViewController(controller!, animated: true)
//                
//                //  navigation controller used to push the view controller onto the navigation stack. ensuring the controller has the Back button functionality
//            }
//            
//            let alertController = UIAlertController(title: "Memo selected",
//                                                    message:  "Selected row: \(indexPath.row) (\(memo))",
//                preferredStyle: .alert)
//            // UIAlertController with a title and message, can either be .alert (which we are using) or .actionsheet. The action sheet is used when more than two or three options are needed, as it stacks the buttons on top of each other.
//            
//            let actionCancel = UIAlertAction(title: "Cancel",
//                                             style: .cancel,
//                                             handler: nil) // add the two buttons to the Alert Controller, and line 20 displays the controller.
//            let actionDetails = UIAlertAction(title: "Show Details",
//                                              style: .default,
//                                              handler: actionHandler)
//            alertController.addAction(actionCancel)
//            alertController.addAction(actionDetails)
//            present(alertController, animated: true, completion: nil)
//        }
//        
        /*
         // Override to support conditional editing of the table view.
         override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
         }
         */
        
        override func tableView(_ tableView: UITableView,
                                commit editingStyle: UITableViewCell.EditingStyle,
                                forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // THIS is what allows you to delete data from the contacts page
                let memo = memos[indexPath.row] as? Memo
                let context = appDelegate.persistentContainer.viewContext
                context.delete(memo!)
                do {
                    try context.save()
                    
                    // The try/catch is here to force the context to save changes causes the object to be deleted from the data store immediately.
                }
                catch  {
                    fatalError("Error saving context: \(error)")
                }
                
                loadDataFromDatabase() // reloads the data from the database into the contacts array.
                
                tableView.deleteRows(at: [indexPath], with: .fade) // removes the row from the table vis animation.
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array,
                //and add a new row to the table view
            }
        }
        
        /*
         // Override to support rearranging the table view.
         override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
         
         }
         */
        
        /*
         // Override to support conditional rearranging of the table view.
         override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
         }
         */
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "EditMemo" {
                let memoController = segue.destination as? MemoViewController
                let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
                let selectedMemo = memos[selectedRow!] as? Memo
                memoController?.currentMemo = selectedMemo!
            }
        }
    
    func formatDateShort(_ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    }
    /*
     
     Default, Subtitle, Value1, and Value2. These can be set in either code or in Interface builder. Default has a single title and an optional image, whereas Subtitle adds the option of a subtitle below the title. (Figure 12.1 uses the subtitle style.) Value1 does not permit images and right aligns the subtitle in blue, and Value2 puts the title in blue and aligns the title and subtitle against each other down the middle.
     
     In Swift, the question mark (?) is used for optional chaining. Optional chaining is a feature that allows you to access properties, methods, and subscripts of an optional that might currently be nil.
     
     
     \*
     Core Data is an object wrapper on top of a data store—typically an SQLite database.
     */

