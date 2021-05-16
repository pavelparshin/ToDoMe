//
//  CoreDataManager.swift
//  ToDoMe
//
//  Created by Pavel Parshin on 15.05.2021.
//

import UIKit
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    //MARK: - Work with Categories
    func newCategory(name: String) -> Category {
        let newCategory = Category(context: context)
        newCategory.name = name
        saveContext()
        
        return newCategory
    }
    
    func loadCategory() -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
    //MARK: - Work with ToDo Items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) -> [Item] {
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            return try context.fetch(request)
        } catch {
            print(error)
            return []
        }
    }
    
    func createItem(with title: String, from category: Category) -> Item {
        let newItem = Item(context: context)
        newItem.title = title
        newItem.parentCategory = category
        saveContext()
        
        return newItem
    }
    
    func loadItemsFromCategory(category: Category) -> [Item] {
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "parentCategory.name MATCHES %@", category.name!),
            NSPredicate(format: "isDone == NO", true)
        ])
        return loadItems(predicate: predicate)
    }
    
    func numberOfDoneItemsFromCategory(category: Category) -> Int {
        return loadItemsFromCategory(category: category).count
    }
    
    func loadDoneItems() -> [Item] {
        let predicate = NSPredicate(format: "isDone == YES", true)
        return loadItems(predicate: predicate)
    }
    
    func numberOfDoneItems() -> Int {
        loadDoneItems().count
    }

    func numberOfAllItems() -> Int {
        loadItems().count
    }
}
