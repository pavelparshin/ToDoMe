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
        
        setUI()
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
    
    //MARK: SetUp User Interface
    private func setUI() {
        
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
        
        view.backgroundColor = K.shared.lightColour
        tableView.backgroundColor = K.shared.lightColour
        navigationController?.navigationBar.tintColor = K.shared.doneColor
        navigationItem.rightBarButtonItem?.tintColor = K.shared.doneColor
    }
    
    //MARK: work with UISwipeActionsConfiguration
    private func doneItemAAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Done") { _, _, complition in
            self.items[indexPath.row].isDone.toggle()
            
            if self.showIsDone && !self.items[indexPath.row].isDone  {
                self.deleteItemRow(with: indexPath)
            } else {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            self.coreDataManager.saveContext()
            complition(true)
        }
        action.backgroundColor = K.shared.doneColor
        action.image = UIImage(systemName: K.shared.checkmarkDone)
        return action
    }
    
    private func deleteItemAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, complition in
            self.coreDataManager.deleteObject(with: self.items[indexPath.row])
            self.deleteItemRow(with: indexPath)
        }
        action.backgroundColor = K.shared.deleteColor
        action.image = UIImage(systemName: K.shared.deleteMark)
        return action
    }
    
    private func deleteItemRow(with indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        if selectedCategory == nil {
            cell.detailTextLabel?.text = item.parentCategory?.name
            cell.detailTextLabel?.textColor = .gray
        } else {
            cell.detailTextLabel?.text = nil
        }
        
        if item.isDone {
            cell.textLabel?.textColor = .gray
            cell.accessoryType = .checkmark
            cell.tintColor = K.shared.doneColor
        } else {
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        }
        
        cell.selectedBackgroundView = K.shared.getColorForCell()
        cell.backgroundColor = K.shared.lightColour
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [doneItemAAction(at: indexPath)])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [deleteItemAction(at: indexPath)])
    }
}
