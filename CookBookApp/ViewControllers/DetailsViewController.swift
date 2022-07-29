//
//  DetailsViewController.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 14.07.2022.
//

import RealmSwift
import UIKit


class DetailsViewController: UIViewController {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var recipeTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var mainVCdelegate: MaincVCDelegate?
    
    var dish: Dish?
    
    
    var nameOfIngredient: [String] = []
    var countofIngredient: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getIngredient()
        setupDoneButton()

        scrollView.keyboardDismissMode = .onDrag
        addObservers()
        
        
    }
    
    
    private func configure() {
        dish = mainVCdelegate?.getDish()

        dishNameLabel.text = dish?.name
        
        guard let imageData = dish?.image else { return }
        guard let image = UIImage(data: imageData) else { return }
        dishImageView.image = image
        
        recipeTextView.text = dish?.recipe
        print("\(String(describing: dish?.ingridients))")
        
        
    }
    
    
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dish?.ingridients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = nameOfIngredient[indexPath.row]
        content.secondaryText = countofIngredient[indexPath.row]
        content.textProperties.color = .black
        content.secondaryTextProperties.color = .gray
        cell.contentConfiguration = content
        
        
        return cell
    }
    
    func getIngredient() {
        guard let ingredients = dish?.ingridients else { return }
        
        for ingredient in ingredients {
            nameOfIngredient.append(ingredient.name)
            countofIngredient.append(ingredient.note)
        }
    }
    
    
}

extension DetailsViewController: UITextViewDelegate, UITextFieldDelegate {
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
        recipeTextView.inputAccessoryView = toolBar
        
    }
    
    @objc func didTapDone() {
        recipeTextView.resignFirstResponder()
    }
    
        private func addObservers(){
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
    
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        }
    
        @objc func keyboardWillShow(sender: NSNotification) {
            self.view.frame.origin.y = -300 // Move view 150 points upward
        }
    
        @objc func keyboardWillHide(sender: NSNotification) {
            self.view.frame.origin.y = 0 // Move view to original position
        }
}
