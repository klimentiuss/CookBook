//
//  Ingredient.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 23.07.2022.
//

import Foundation
import RealmSwift

class Ingredient {
    
    var ingredientName = ""
    var ingredientCount = ""
    
}

class Strudel {
        
    let dish = Dish()
    
    let strudelreciepe =
    """
Готовим тесто. Cмешиваем яйцо, подсолнечное масло, теплый яблочный сок, сахар и соль. Перемешиваем венчиком. Добавляем муку и замешиваем тесто. Вымешиваем 10 минут минимум!!
Заворачиваем тесто в пленку и оставляем на 30 минут при комнатной температуре.
Для приготовления начинки яблоки очищаем и нарезаем небольшими кусочками. Поливаем соком лимона и перемешиваем. Добавляем изюм (заранее вымоченный в воде или коньяке 20 минут), сахар, корицу и перемешиваем. Отставляем в сторону.
Раскатываем тесто в пласт толщиной минимум 2 мм!! Посыпаем панировочными сухарями.
Выкладываем начинку на раскатанное тесто, не доходя 2 см до краев. Заворачиваем в рулет. Края подворачиваем под рулет.
Смазываем яйцом. Делаем проколы в тесте ножом.
Выпекаем штрудель с яблоками в разогретой духовке 35 минут при 180 градусах.
Советую есть яблочный штрудель со взбитыми сливками или мороженым.
"""
    
    let ingredientsOfStrudel = ["Яйцо" : "2 шт", "Масло подсолнечное" : "40 г", "Яблочный сок" : "90 мл", "Соль" : "1/4 ч. ложки", "Сахар" : "5 ст. ложки", "Мука" : "300 г", "Яблоки кислые" : "3 шт.", "Сок лимона" : "Пол лимона", "Корица молотая" : "1/2 ч. ложки", "Панировочные сухари" : "2 ч. ложки"]
    
    
    func getIngredients() -> List<Ingridients> {

        let dishList = dish.ingridients
        
        for ingredient in ingredientsOfStrudel {
            let ingredients = Ingridients()

            ingredients.name = ingredient.key
            ingredients.note = ingredient.value
            dishList.append(ingredients)
           
        }
     
        StorageManager.shared.add(ingredients: dishList)
        
        return dishList
    }
    
}
