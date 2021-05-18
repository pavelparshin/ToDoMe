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
        
        setUI()
        categoryTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        allItemButton.layer.cornerRadius = allItemButton.frame.width / 2
        doneItemsButton.layer.cornerRadius = doneItemsButton.frame.width / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toDoItemsTV = segue.destination as! ToDoItemsTableViewController
        
        if segue.identifier == "showItems" {
            toDoItemsTV.selectedCategory = sender as? Category
        } else if segue.identifier == "showDoneItemsSegue" {
            toDoItemsTV.showIsDone = true
        }
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
    
    private func setUI() {
        allItemButton.setTitle("\(coreDataManager.numberOfAllItems())", for: .normal)
        allItemButton.setTitleColor(K.shared.lightColour, for: .normal)
        allItemButton.backgroundColor = K.shared.allItemsColour
        
        doneItemsButton.setTitle("\(coreDataManager.numberOfDoneItems())", for: .normal)
        doneItemsButton.setTitleColor(K.shared.lightColour, for: .normal)
        doneItemsButton.backgroundColor = K.shared.doneColor
        
        view.backgroundColor = K.shared.lightColour
        categoryTableView.backgroundColor = K.shared.lightColour
        navigationItem.rightBarButtonItem?.tintColor = K.shared.doneColor
    }
    
    private func deleteCategoryAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, complition in
            self.coreDataManager.deleteAllItems(in: self.categories[indexPath.row])
            self.deleteCategoryRow(with: indexPath)
        }
        action.backgroundColor = K.shared.deleteColor
        action.image = UIImage(systemName: K.shared.deleteMark)
        
        return action
    }
    
    private func deleteCategoryRow(with indexPath: IndexPath) {
        categories.remove(at: indexPath.row)
        categoryTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - UITableViewDataSource
extension MainPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.backgroundColor = K.shared.lightColour
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

//MARK: - UITableViewDelegate
extension MainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItems", sender: categories[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [deleteCategoryAction(at: indexPath)])
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        viewWillAppear(true)
    }
}

