//
//  AddViewController.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 14.07.2022.
//

import UIKit

protocol AddViewControllerDelegate {
    func reloadData()
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var dishNameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingridientsTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AddViewControllerDelegate?
    
    var ingredients: [Ingredient] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDoneButton()
        //    addObservers()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DataManager.shared.ingredients = []
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
    
    
    @IBAction func nameTextField(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func addIngridientPressed(_ sender: Any) {
        showAlert(withtitle: "Ingridient", andMessage: "Add ingredient and quantity")
    }
    
}

//MARK: - Work with PickerController

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

//MARK: - Work with DataBase

extension AddViewController {
    func saveNewDish() {
        
        var dish = Dish()
                
        for ingredient in ingredients {
            let newIngredient = Ingridients()
            newIngredient.name = ingredient.ingredientName
            newIngredient.note = ingredient.ingredientCount
            dish.ingridients.append(newIngredient)
        }
        
        //сделать проверку на дурака
        guard let dishName = dishNameTextField.text else { return }
        guard let dishImage = imageView.image else { return }
        guard let dishRecipe = ingridientsTextView.text else { return }
        let dishIngredient = dish.ingridients
        
        
        guard let dishImageData = dishImage.jpegData(compressionQuality: 1.0) else { return }
        
         dish = Dish(value: [
            "name": dishName,
            "image": dishImageData,
            "recipe": dishRecipe,
            "ingridients": dishIngredient
        ])
                
        DispatchQueue.main.async {
            StorageManager.shared.save(dish: dish)
        }
        
    }
}

//MARK: - Work with Keyboard

extension AddViewController: UITextViewDelegate, UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setupDoneButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Int(view.frame.size.width), height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        ingridientsTextView.inputAccessoryView = toolBar
        dishNameTextField.inputAccessoryView = toolBar
    }
    
    @objc func didTapDone() {
        ingridientsTextView.resignFirstResponder()
        dishNameTextField.resignFirstResponder()
    }
    
    //доработать (движение контента вверх)
    
    //    private func addObservers(){
    //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
    //
    //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    //    }
    //
    //    @objc func keyboardWillShow(sender: NSNotification) {
    //        self.view.frame.origin.y = -100 // Move view 150 points upward
    //    }
    //
    //    @objc func keyboardWillHide(sender: NSNotification) {
    //        self.view.frame.origin.y = 0 // Move view to original position
    //    }
}

//MARK: - Work with AlertController

extension AddViewController {
    private func showAlert(withtitle title: String, andMessage message: String, ingredient:  Ingredient? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addIngredient(withIngredient: ingredient) { name, count in
            if let ingredient = ingredient {
                self.editIngredient(ingredient: ingredient, with: name, and: count)
            } else {
                self.saveIngredient(with: name, and: count)
            }
        }
        present(alert, animated: true)
    }
    
    func saveIngredient(with name: String, and count: String) {
        let newIngredient = Ingredient()
        
        newIngredient.ingredientName = name
        newIngredient.ingredientCount = count
        
        DataManager.shared.ingredients.append(newIngredient)
        self.ingredients = DataManager.shared.ingredients
        
        DispatchQueue.main.async {
            let rowIndex = IndexPath.init(row: self.ingredients.count - 1, section: 0)
            self.tableView.insertRows(at: [rowIndex], with: .automatic)
        }
    }
    
    func editIngredient(ingredient: Ingredient, with name: String, and count: String) {
        ingredient.ingredientName = name
        ingredient.ingredientCount = count
        self.tableView.reloadData()
    }
}

//MARK: - Work with TableView

extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingerdient = ingredients[indexPath.row]
        
        cell.configure(with: ingerdient)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            let ingerdient = self.ingredients[indexPath.row]
            self.showAlert(withtitle: "Edit", andMessage: "Update data", ingredient: ingerdient)
            isDone(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, isDone in
            self.ingredients.remove(at: indexPath.row)
            DataManager.shared.ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
}


