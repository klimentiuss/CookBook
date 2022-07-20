//
//  AddViewController.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 14.07.2022.
//

import UIKit

protocol addViewControllerDelegate {
    func reloadData()
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var dishNameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var delegate: addViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func uploadPressed() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func saveButtonPressed() {
        saveNewDish()
        delegate?.reloadData()
        dismiss(animated: true)
    }
    
    @IBAction func cancelButton() {
        dismiss(animated: true)
    }
    
    
    
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageView.image = image
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddViewController {
    func saveNewDish() {
        let defaultDishes = DishList()
        
        //сделать проверку на дурака
        guard let dishName = dishNameTextField.text else { return }
        guard let dishImage = imageView.image else { return }
        guard let dishRecipe = textView.text else { return }

        guard let dishImageData = dishImage.jpegData(compressionQuality: 1.0) else { return }
        
        let newDish = Dish(value: [
            "name": dishName,
            "image": dishImageData,
            "recipe": dishRecipe])
        
        defaultDishes.dishes.insert(contentsOf: [newDish], at: 0)
        
        DispatchQueue.main.async {
            StorageManager.shared.save(dishList: [defaultDishes])
        }
    }
}

