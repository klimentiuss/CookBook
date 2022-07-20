//
//  CollectionViewCell.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 14.07.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    
    var isEditing: Bool = false {
        didSet {
            selectLabel.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                selectLabel.text = isSelected ? "X" : ""
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectLabel.layer.cornerRadius = 15
        self.selectLabel.layer.masksToBounds = true
        self.selectLabel.layer.borderColor = UIColor.white.cgColor
        self.selectLabel.layer.borderWidth = 1.0
        self.selectLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

}

extension CollectionViewCell {
    func configure(with dish: Dish) {
        
        guard let imageName = dish.image else { return }
        let image = UIImage(data: imageName)
        
        let dishName = dish.name
        
        dishImage.image = image
        dishNameLabel.text = dishName
    }
}
