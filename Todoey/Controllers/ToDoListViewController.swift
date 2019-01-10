//
//  ViewController.swift
//  Todoey
//
//  Created by Ryan David Forsyth on 2019-01-07.
//  Copyright © 2019 Ryan F. All rights reserved.
//


import UIKit

class ToDoListViewController: UITableViewController {

    var taskArray = [Task]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("tasks.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        loadItems()
        }
        
    // Methods for what the cells should display, and for how many rows are required
    
    //How many rows will be displayed:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskArray.count
        
    }
    
    //What the cells should display:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for : indexPath)
        
        let task = taskArray[indexPath.row]
        
        cell.textLabel?.text = task.title
        
        cell.accessoryType = task.done ? .checkmark : .none
        
        return cell
    }
    
    //What to do when a cell is selected/tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        taskArray[indexPath.row].done = !taskArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Task", message: "", preferredStyle: .alert)
        
        //What happens when user presses Add button:
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newTask = Task(title: textField.text!)
            
            self.taskArray.append(newTask)
            
           self.saveItems()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new task"
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(taskArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error encoding task array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                taskArray = try decoder.decode([Task].self, from: data)
            }
            catch{
                print("\(error)")
            }
        }
        
    }

}

