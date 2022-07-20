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
    @objc dynamic var imageString: String?
    @objc dynamic var image: Data?
    @objc dynamic var recipe = ""
    @objc dynamic var ingridients: Ingridients?
}

class Ingridients: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
}


class DishList: Object {
    let dishes = List<Dish>()
}
