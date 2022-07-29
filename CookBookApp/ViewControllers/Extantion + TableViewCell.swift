//
//  Extantion + TableViewCell.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 22.07.2022.
//

import UIKit

extension UITableViewCell {
    func configure(with ingredient: Ingredient) {
        var content = defaultContentConfiguration()
        content.text = ingredient.ingredientName
        content.secondaryText = ingredient.ingredientCount
        content.textProperties.color = .black
        content.secondaryTextProperties.color = .gray
        contentConfiguration = content
    }
    
//    func configure(with dish: Dish?) {
//        var nameOfIngredient: [String] = []
//        var countofIngredient: [String] = []
//        
//        guard let ingredients = dish?.ingridients else { return }
//        
//        for i in ingredients {
//            nameOfIngredient.append(i.name)
//            countofIngredient.append(i.note)
//        }
//        
//        var content = defaultContentConfiguration()
//        content.text = nameOfIngredient[]
//        
//        contentConfiguration = content
//    }
}
