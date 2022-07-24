//
//  Extantion + AlertController.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 23.07.2022.
//

import Foundation
import UIKit


extension UIAlertController {
    
    func addIngredient(withIngredient: Ingredient? = nil , completion: @escaping (String, String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let name = self.textFields?.first?.text else { return }
            guard !name.isEmpty else { return }
            
            guard let count = self.textFields?.last?.text else { return }
            guard !count.isEmpty else { return }
            
            
            completion(name, count)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "Oil"
            textField.text = withIngredient?.ingredientName
        }
        addTextField { textField in
            textField.placeholder = "2 spoon"
            textField.text = withIngredient?.ingredientCount
        }
    }
}
