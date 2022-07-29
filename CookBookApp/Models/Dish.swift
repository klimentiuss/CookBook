//
//  Dish.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 14.07.2022.
//

import RealmSwift
import UIKit

class Dish: Object {
    @objc dynamic var name = ""
    @objc dynamic var image: Data?
    @objc dynamic var recipe = ""
    var ingridients = List<Ingridients>()
}

class Ingridients: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
}



