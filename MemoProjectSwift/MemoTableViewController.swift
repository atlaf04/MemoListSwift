//
//  MemoTableViewController.swift
//  MemoProjectSwift
//
//  Created by Lexi Francis on 4/20/24.
//

import UIKit
import CoreData

class MemoTableViewController: UITableViewController {

   
  
  
    var memos:[NSManagedObject] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        
        loadDataFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // This ensures that the data is reloaded from the database in line 2. Line 3 reloads the data in the table itself.
        
        loadDataFromDatabase()
        tableView.reloadData()
    }

  func loadDataFromDatabase() {
      
      // The code starts by reading from the default settings
      
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: Constants.kSortField) // retrieves the sort field and sort direction using the keys defined in Constants.swift.
      
      
        let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending)
        //Set up Core Data Context
        let context = appDelegate.persistentContainer.viewContext
        //Set up Request
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        //Specify sorting
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
      
      // NSSortDescriptor is a class that contains instructions on how to order objects.
      
        let sortDescriptorArray = [sortDescriptor]
        //to sort by multiple fields, add more sort descriptors to the array
        request.sortDescriptors = sortDescriptorArray
        do {
            memos = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
   }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // this was changed this to 1 to make the number of sections appear
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count // returns the number of elements in the memo array.
        
        // Just below is the tableView(_ tableView:numberOfRowsInSection:) method. This returns the number of data rows a particular section has, so that iOS knows how many table cells to present. For now, the number of rows will equal how many names are in the array given previously. (Later, it will return how many Contact objects are in the database.)
        
        // The tableView(_ tableView:cellForRowAt indexPath:) method is the workhorse method when it comes to tables.
        
        
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = memos[indexPath.row] as? Memo
        
        // getting the contact object associated with the selected row
        
        let memo = selectedMemo!.memoName!
        
        let actionHandler = { (action:UIAlertAction!) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // gets a reference to the storyboard named Main
            
            
            let controller = storyboard.instantiateViewController(withIdentifier: "MemoController")// instantiates an instance of the view controller using an identifier.
                as? MemoViewController
            controller?.currentMemo = selectedMemo
            self.navigationController?.pushViewController(controller!, animated: true)
            
                //  navigation controller used to push the view controller onto the navigation stack. ensuring the controller has the Back button functionality
        }
        
        let alertController = UIAlertController(title: "Contact selected",
                                                message:  "Selected row: \(indexPath.row) (\(name))",
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
}
/*
 
 Default, Subtitle, Value1, and Value2. These can be set in either code or in Interface builder. Default has a single title and an optional image, whereas Subtitle adds the option of a subtitle below the title. (Figure 12.1 uses the subtitle style.) Value1 does not permit images and right aligns the subtitle in blue, and Value2 puts the title in blue and aligns the title and subtitle against each other down the middle.
 
 In Swift, the question mark (?) is used for optional chaining. Optional chaining is a feature that allows you to access properties, methods, and subscripts of an optional that might currently be nil.
 
 
 \*
 Core Data is an object wrapper on top of a data store—typically an SQLite database.
 */
