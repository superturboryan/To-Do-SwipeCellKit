//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ryan David Forsyth on 2019-01-12.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import CoreData

class CatViewController: UITableViewController {

    var catArray = [Cat]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCats()
    }

    // MARK: - Table view datasource method
    
    // # of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    
    //What to display in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath)
        
        let cat = catArray[indexPath.row]
        
        cell.textLabel?.text = cat.name
        
        return cell
    }

    
    
    
    //MARK: - Add new categories (button)
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Category", message: "", preferredStyle: .alert)
        
        //What happens when add button is pressed
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCat = Cat(context: self.context)
            
            newCat.name = textField.text
            
            self.catArray.append(newCat)
            
            self.saveCats()
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
    
    func saveCats(){
        
        do{
            try context.save()
        }
        catch{
            print("Error saving categories \(error)")
        }
        
        self.tableView.reloadData()
    }
    
//    Default parameters can be declared with an = after declaring parameter type
//       params?? with request : NSFetchRequest<Cat> = Task.fetchRequest()
        func loadCats() {

        let request : NSFetchRequest<Cat> = Cat.fetchRequest()
            
        do{
            catArray = try context.fetch(request)
        }
        catch{
            print("Error loading context \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: -  Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[indexPath.row] 
        }
    }
    
}
