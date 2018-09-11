//
//  BucketListViewController.swift
//  BucketList
//
//  Created by Quang Nguyen on 9/8/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit
import CoreData

class Task {
    var objective: String
    var createdAt: String
    
    init(objective:String, createdAt: String) {
        self.objective = objective
        self.createdAt = createdAt
    }
}

class BucketListViewController: UITableViewController {
    
    var tasks:[Task] = []
    
    let managedObjectContext =
        (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer
        .viewContext
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        for task in self.tasks {
            print(task.objective)
        }
    }
    
    override func viewDidLoad() {
        TaskModel.getAllTasks() {
            data, response, error in
            do {
                if let tasks = try JSONSerialization.jsonObject(
                    with: data!,
                    options: .mutableContainers
                    ) as? NSDictionary {
                    self.loadTasks(fromJsonData: tasks)
                    self.tableView.reloadData()
                }
            } catch {
                print("Something went wrong")
            }
        }
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
  
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyCell", for: indexPath)
        
        
        cell.textLabel?.text = tasks[indexPath.row].objective
        return cell
    }
    

    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController =
            segue.destination as! UINavigationController
        let addItemViewController =
            navigationController.topViewController as! AddItemViewController
        
        addItemViewController.delegate = self

    }
    
    func loadTasks(fromJsonData data: NSDictionary) {
        guard let tasksDataArray = data.value(forKey: "tasks") as? NSArray else { return }
        self.tasks = []
        for taskData in tasksDataArray {
            guard let taskData = taskData as? NSDictionary else { return }
            self.tasks.append(
                Task(objective: "\(taskData.value(forKey: "objective") ?? "nil")",
                    createdAt: "\(taskData.value(forKey: "createdAt") ??  "nil")"
                )
            )
            print(self.tasks)
        }
    }
    
    func fetchAllTasks() {
        TaskModel.getAllTasks() { data, response, error in
            do {
                if let tasks = try JSONSerialization.jsonObject(
                        with: data!, options: .mutableContainers
                        ) as? NSDictionary {
                    self.loadTasks(fromJsonData: tasks)
                    self.tableView.reloadData()
                }
            } catch {
                print("Something went wrong")
            }
        }
    }

}

// MARK: - AddItemViewControllerDelegate
extension BucketListViewController: AddItemViewControllerDelegate {
    
    func cancelButtonPressed(by controller: AddItemViewController) {

        dismiss(animated: true, completion: nil)
    }
    
    func itemSaved(by controller: AddItemViewController,
                   withObjective objective: String,
                   at indexPath: IndexPath?) {
        
        if let indexPath = indexPath {
//            let item = items[indexPath.row]
//            item.text = text
            
        } else {
            print("SENDING POST REQUEST FOR: \(objective)")
            TaskModel.addTaskWithObjective(objective: objective) { data, response, error in
                self.fetchAllTasks()
            }
        }
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}

