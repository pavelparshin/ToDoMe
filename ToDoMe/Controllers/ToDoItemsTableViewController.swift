//
//  ToDoItemsTableViewController.swift
//  ToDoMe
//
//  Created by Pavel Parshin on 15.05.2021.
//

import UIKit
import CoreData

class ToDoItemsTableViewController: UITableViewController {
    
    private let coreDataManager = CoreDataManager.shared
    private var items = [Item]()
    
    var selectedCategory: Category?
    var showIsDone: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedCategory?.name
        
        if let selectedCategory = selectedCategory {
            title = selectedCategory.name
            items = coreDataManager.loadItemsFromCategory(category: selectedCategory)
        } else if !showIsDone {
            title = "All items"
            items = coreDataManager.loadItems()
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            title = "All Done items"
            items = coreDataManager.loadDoneItems()
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        AlertController.shared.showAlert(from: self, with: "Add new Item") { itemName in
            self.createItem(with: itemName)
        }
    }
    
    private func createItem(with title: String) {
        let newItem = coreDataManager.createItem(with: title, from: selectedCategory!)
        items.append(newItem)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        if item.isDone {
            cell.textLabel?.textColor = .gray
            cell.accessoryType = .checkmark
        } else {
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isDone.toggle()
        coreDataManager.saveContext()
        
        tableView.reloadData()
        
    }
}
