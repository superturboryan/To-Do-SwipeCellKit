//
//  ViewController.swift
//  Todoey
//
//  Created by Ryan David Forsyth on 2019-01-07.
//  Copyright © 2019 Ryan F. All rights reserved.
//


import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{

    var tasks : Results<Task>?
    
    let realm = try! Realm()
    
    var selectedCategory : Cat? {
        didSet{
            loadTasks()
        }
    }
    
    // CONTEXT USED IN CORE DATA PERSISTENT CONTAINER
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchBar.delegate = self       //OPTIONAL, CAN CONTROL+DRAG SEARCHBAR TO VC IN STORYBOARD EDITOR
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadTasks()
        }
    
    //IB Outlets:
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    
    // Methods for what the cells should display, and for how many rows are required
    
    //How many rows will be displayed:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        return tasks?.count ?? 1
    }
    
    //What the cells should display:
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for : indexPath)
        
        if let task = tasks?[indexPath.row]{
            cell.textLabel?.text = task.title
            
            cell.accessoryType = task.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    //Delegate methods
    //What to do when a cell is selected/tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if item is not nil...
        if let task = tasks?[indexPath.row] {
            do{
                try realm.write {
//                    realm.delete(task)
                    task.done = !task.done
                }
            }
            catch{
                print("Error saving done status of task \(error)")
            }
        }
        
        //Core data stuff:
//        context.delete(taskArray[indexPath.row])
//
//        taskArray.remove(at: indexPath.row)
      
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Task", message: "", preferredStyle: .alert)
        
        //What happens when user presses Add button:
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCat = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newTask = Task()
                        newTask.title = textField.text!
                        newTask.dateCreated = Date()
                        currentCat.tasks.append(newTask)
                    }
                }
                catch{
                    print("Error saving new tasks \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new task"
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data manipulation method
    
    func saveTasks(){
        
        
    }
    
    func loadTasks(){
        
        tasks = selectedCategory?.tasks.sorted(byKeyPath: "title", ascending: true)
        

        //Core data code:
//        let categoryPredicate = NSPredicate(format: "parentCategory.name CONTAINS %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }
//        else{
//            request.predicate = categoryPredicate
//        }
//
//        do{
//          taskArray = try  context.fetch(request)
//          }
//        catch{print("Error loading context \(error)")}

        tableView.reloadData()

    }
 
}

//MARK: - Search bar methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        tasks = tasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        //Core data stuff:
//        let request : NSFetchRequest<Task> = Task.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)       //[IGNORE PARAMETERS - c : case, d : diacritic]
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadTasks(with: request, predicate: predicate)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadTasks()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

