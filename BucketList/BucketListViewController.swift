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
    var id: Int
    var objective: String
    var createdAt: String
    
    init(id: Int, objective: String, createdAt: String) {
        self.id = id
        self.objective = objective
        self.createdAt = createdAt
    }
}

class BucketListViewController: UITableViewController {
    
    var tasks:[Task] = []
    
    override func viewDidLoad() {
        fetchAllTasks()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyCell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].objective
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let thisTask = tasks[indexPath.row]
        TaskModel.deleteTaskWithId(thisTask.id)
        tasks.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let navigationController = segue.destination as! UINavigationController
        let addItemViewController = navigationController.topViewController as! AddItemViewController
        
        addItemViewController.delegate = self
        if let indexPath = sender as? IndexPath {
            addItemViewController.indexPath = indexPath
            addItemViewController.item = tasks[indexPath.row].objective
        }
    }
    
    func loadTasks(fromJsonData data: NSDictionary) {
        guard let tasksDataArray = data.value(forKey: "tasks") as? NSArray else { return }
        self.tasks = []
        for taskData in tasksDataArray {
            guard let taskData = taskData as? NSDictionary else { return }
            self.tasks.append(
                Task(id: taskData.value(forKey: "id") as! Int,
                    objective: "\(taskData.value(forKey: "objective") ?? "nil")",
                    createdAt: "\(taskData.value(forKey: "createdAt") ??  "nil")"
                )
            )
            print(self.tasks)
        }
    }
    
    func fetchAllTasks() {
        TaskModel.getAllTasks() { data, response, error in
            do {
                if let tasks = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
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
        // If edit mode
        if let indexPath = indexPath {
            let thisTask = tasks[indexPath.row]
            TaskModel.updateTaskWithId(thisTask.id, newObjective: objective) { data, response, error in
                self.fetchAllTasks()
            }
        // If add mode
        } else {
            TaskModel.addTaskWithObjective(objective: objective) { data, response, error in
                self.fetchAllTasks()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

