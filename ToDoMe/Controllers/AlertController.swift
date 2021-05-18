//
//  AlertController.swift
//  ToDoMe
//
//  Created by Pavel Parshin on 15.05.2021.
//

import UIKit

struct AlertController {
    static let shared = AlertController()
    private init() {}
    
    func showAlert(from view: UIViewController, with title: String, complition: @escaping(String) -> ()) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "\(title) here"
            textField.tintColor = K.shared.doneColor
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(K.shared.deleteColor, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            guard let newCategoryTF = alert.textFields?.first?.text, newCategoryTF != "" else { return }
            complition(newCategoryTF)
        }
        action.setValue(K.shared.doneColor, forKey: "titleTextColor")
        
        alert.addAction(action)
        view.present(alert, animated: true)
    }
}
