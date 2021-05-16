//
//  ViewController.swift
//  ToDoMe
//
//  Created by Pavel Parshin on 15.05.2021.
//

import UIKit

class MainPageViewController: UIViewController {

    @IBOutlet var allItemButton: UIButton!
    @IBOutlet var doneItemsButton: UIButton!
    @IBOutlet var categoryTableView: UITableView!
    
    let coreDataManager = CoreDataManager.shared
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = coreDataManager.loadCategory()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let allItems = "All Items: \(coreDataManager.numberOfAllItems())"
        allItemButton.setTitle(allItems, for: .normal)
        
        let doneItems = "Done items: \(coreDataManager.numberOfDoneItems())"
        doneItemsButton.setTitle(doneItems, for: .normal)
        
        categoryTableView.reloadData()
    }

    @IBAction func allItemsButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func doneItemsButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func newCategoryPressed(_ sender: UIBarButtonItem) {
        AlertController.shared.showAlert(from: self, with: "Add new Category") { categoryName in
            self.createCategory(name: categoryName)
        }
    }
    
    private func createCategory(name: String) {
        let newCategory = coreDataManager.newCategory(name: name)
        self.categories.append(newCategory)
        categoryTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toDoItemsTV = segue.destination as! ToDoItemsTableViewController
        
        if segue.identifier == "showItems" {
            toDoItemsTV.selectedCategory = sender as? Category
        } else if segue.identifier == "showDoneItemsSegue" {
            toDoItemsTV.showIsDone = true
        }
    }
}

//MARK: - UITableViewDataSource
extension MainPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        let numberOfItems = coreDataManager.numberOfDoneItemsFromCategory(category: category)
        if numberOfItems != 0 {
            cell.detailTextLabel?.text = String(numberOfItems)
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
}

extension MainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItems", sender: categories[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

