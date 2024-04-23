//
//  MemoTableViewController.swift
//  MemoProjectSwift
//
//  Created by Lexi Francis on 4/20/24.
//

import UIKit
import CoreData

class MemoTableViewController: UITableViewController {

    var memos: [Memo] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadDataFromDatabase()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromDatabase()
        tableView.reloadData()
    }

    func loadDataFromDatabase() {
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: Constants.kSortField) ?? ""
        let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending)

        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: sortField, ascending: sortAscending)]

        do {
            memos = try context.fetch(request)
        } catch {
            print("Could not fetch memos: \(error)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath)

        let memo = memos[indexPath.row]
        cell.textLabel?.text = memo.memo
        cell.detailTextLabel?.text = "\(memo.subject ?? "") - \(memo.date?.description ?? "")" // Include date in detail text label

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = appDelegate.persistentContainer.viewContext
            context.delete(memos[indexPath.row])

            do {
                try context.save()
                loadDataFromDatabase()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Could not save context after deleting memo: \(error)")
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMemo = memos[indexPath.row]
        let title = selectedMemo.subject ?? ""
        let content = selectedMemo.memo ?? ""

        let alertController = UIAlertController(title: "Memo selected",
                                                message: "Title: \(title)\nContent: \(content)",
                                                preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
}
