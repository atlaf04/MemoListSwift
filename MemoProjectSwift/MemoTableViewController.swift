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
    
    func loadDataFromDatabase() {
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: Constants.kSortField)
        let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending)
        //Set up Core Data Context
        let context = appDelegate.persistentContainer.viewContext
        //request
        let request = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemosCell", for: indexPath)

        // Configure cell
        let memo = memos[indexPath.row] as? Memo
        cell.textLabel?.text = memo?.value(forKey: "title") as? String
        cell.detailTextLabel?.text = "\(memo?.value(forKey: "content") as? String ?? "") - Priority: \(memo?.value(forKey: "priority") as? Int ?? 0) - Date: \(memo?.value(forKey: "date") as? String ?? "")"
        cell.accessoryType = .detailDisclosureButton

        return cell
    }
       
    // textLabel property of the cell to set the text that will show up on screen. The data is pulled from the contacts array using the requested row number as the index.
    
       
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedMemo = memos[indexPath.row] as? Memo
            // getting the contact object associated with the selected row
            let memo = selectedMemo!.subject!
            let actionHandler = { (action:UIAlertAction!) -> Void in
                let storyboard = UIStoryboard(name: "Main", bundle: nil) // gets a reference to the storyboard named Main
                let controller = storyboard.instantiateViewController(withIdentifier: "MemoViewController")// instantiates an instance of the view controller using an identifier.
                as? MemoViewController
                controller?.currentMemo = selectedMemo
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

