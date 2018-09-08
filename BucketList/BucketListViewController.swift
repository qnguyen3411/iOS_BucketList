//
//  BucketListViewController.swift
//  BucketList
//
//  Created by Quang Nguyen on 9/8/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController {
    
    var items:[BucketListItem] = []
    
    let managedObjectContext =
        (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer
        .viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
    // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
  
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyCell", for: indexPath)
        
        print(cell)
        guard let text = items[indexPath.row].text else {
            return cell
        }
        cell.textLabel?.text = text
        return cell
    }
    

    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)

    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        managedObjectContext.delete(items[indexPath.row])
        items.remove(at: indexPath.row)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController =
            segue.destination as! UINavigationController
        let addItemViewController =
            navigationController.topViewController as! AddItemViewController
        
        addItemViewController.delegate = self

        
        if segue.identifier == "EditItemSegue" {
            
            let indexPath = sender as! IndexPath
            let item = items[indexPath.row]
            
            addItemViewController.delegate = self
            addItemViewController.indexPath = indexPath
            addItemViewController.item = item.text
        }
    }
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItem")
        do {
            let result = try managedObjectContext.fetch(request)
            print(result)
            items = result as! [BucketListItem]
        } catch {
            print("\(error)")
        }
    }
}

// MARK: - AddItemViewControllerDelegate
extension BucketListViewController: AddItemViewControllerDelegate {
    
    func cancelButtonPressed(by controller: AddItemViewController) {

        dismiss(animated: true, completion: nil)
    }
    
    func itemSaved(by controller: AddItemViewController,
                   withText text: String,
                   at indexPath: IndexPath?) {
        
        if let indexPath = indexPath {
            let item = items[indexPath.row]
            item.text = text
            
        } else {
            print("CREATING ITEM")
            let item = NSEntityDescription.insertNewObject(
                forEntityName: "BucketListItem",
                into: managedObjectContext) as! BucketListItem
            item.text = text
            items.append(item)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}

