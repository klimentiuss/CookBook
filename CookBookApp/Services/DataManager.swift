//
//  DataManager.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 14.07.2022.
//

import Foundation
import UIKit

class DataManager {
    static let shared = DataManager()
    
    func createTempData(_ completion: @escaping () -> Void) {
        if !UserDefaults.standard.bool(forKey: "done") {
            
            
            UserDefaults.standard.set(true, forKey: "done")
            
            let defaultDishes = DishList()
            
            //сделать метод
            guard let strudelImage = UIImage(named: "img1") else { return }
            guard let strudelImageData = strudelImage.jpegData(compressionQuality: 1.0) else { return }
        
            guard let karbonaraImage = UIImage(named: "img2") else { return }
            guard let karbonaraImageData = karbonaraImage.jpegData(compressionQuality: 1.0) else { return }
            
            guard let pizzaImage = UIImage(named: "img3") else { return }
            guard let pizzaImageData = pizzaImage.jpegData(compressionQuality: 1.0) else { return }
            
               
            
            let strudel = Dish(value: ["name": "Штрудель", "image": strudelImageData])
            let karbonara = Dish(value: ["name": "Паста карбонара", "image": karbonaraImageData])
            let pizza = Dish(value: ["name": "Пицца 4 сыра", "image": pizzaImageData])
            
            defaultDishes.dishes.insert(contentsOf: [strudel, karbonara, pizza], at: 0)
            
            DispatchQueue.main.async {
                StorageManager.shared.save(dishList: [defaultDishes])
                completion()
            }
        }
    }
    
    
    
    private init() {}
}
