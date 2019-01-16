//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ryan David Forsyth on 2019-01-12.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import Realm

class CatViewController: UITableViewController {
    
    //MARK: - Variables
    
    let realm = try! Realm()

    var cats : Results<Cat>?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - Upon loading...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCats()
    }

    
    // MARK: - Table view datasource method
    
    // # of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        //Return optional cats?.count, if it IS NIL, then instead return value after "??" X
        return cats?.count ?? 1
    }
    
    //What to display in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath)
        
        cell.textLabel?.text = cats?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }

    
    
    
    //MARK: - Add new categories (button)
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Category", message: "", preferredStyle: .alert)
        
        //What happens when add button is pressed
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCat = Cat()
            
            newCat.name = textField.text!
            
            self.save(category: newCat)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            
            textField = alertTextField
            alertTextField.placeholder = "Enter new category!"
        }
        
        //Don't forget to present!
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    // MARK: - Data manipulation methods, save and load
    
    func save(category : Cat){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error saving categories \(error)")
        }
        
        tableView.reloadData()
    }
    

    func loadCats() {

    cats = realm.objects(Cat.self)
        
    tableView.reloadData()      // reloadData calls data source methods

//    Default parameters can be declared with an = after declaring parameter type
//    with request : NSFetchRequest<Cat> = Task.fetchRequest()
            
//        Core data instructions:
//        let request : NSFetchRequest<Cat> = Cat.fetchRequest()
//
//        do{
//            catArray = try context.fetch(request)
//        }
//        catch{
//            print("Error loading context \(error)")
//        }
    }
    
    // MARK: -  Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = cats?[indexPath.row]
        }
    }
    
}
