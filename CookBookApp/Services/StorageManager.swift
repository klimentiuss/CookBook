//
//  StorageManager.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 14.07.2022.
//

import RealmSwift


class StorageManager {
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init(){}
    
    func save(dish: Dish) {
        write {
            realm.add(dish)
        }
    }
    
    func delete(dish: Dish) {
        write {
            realm.delete(dish.ingridients)
            realm.delete(dish)
        }
    }
    
    func add(ingredients: List<Ingridients>){
        write {
            realm.add(ingredients)
        }
    }
    
    private func write(_ completion: () -> Void ){
        do {
            try realm.write {
               completion()
            }
        } catch let error {
            print(error)
        }
    }
}
