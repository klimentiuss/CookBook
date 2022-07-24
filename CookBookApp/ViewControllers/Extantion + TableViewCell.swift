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
        contentConfiguration = content
    }
}
