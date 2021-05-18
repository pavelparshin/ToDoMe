//
//  Constants.swift
//  ToDoMe
//
//  Created by Pavel Parshin on 18.05.2021.
//

import UIKit

struct K {
    static let shared = K()
    private init() {}
    
    let checkmarkDone = "checkmark.circle"
    let deleteMark = "delete.left"
    let doneColor = UIColor(red: 0.37, green: 0.67, blue: 0.66, alpha: 1.00)
    let lightDoneColour = UIColor(red: 0.64, green: 0.82, blue: 0.79, alpha: 1.00)
    let lightColour = UIColor(red: 0.97, green: 0.95, blue: 0.91, alpha: 1.00)
    let deleteColor = UIColor(red: 0.94, green: 0.35, blue: 0.27, alpha: 1.00)
    
    func getColorForCell() -> UIView {
        let backgroundColorView = UIView()
        backgroundColorView.backgroundColor = lightDoneColour
        return backgroundColorView
    }
}
