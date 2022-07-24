//
//  IngredientsTableView.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 20.07.2022.
//

import UIKit

class IngredientsTableView: UITableView, UITableViewDelegate,  UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.configure()
        
        
        return cell
    }
    

    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
   
}

