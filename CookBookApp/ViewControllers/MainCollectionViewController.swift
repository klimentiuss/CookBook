//
//  MainCollectionViewController.swift
//  CookBookApp
//
//  Created by Daniil Klimenko on 14.07.2022.
//

import RealmSwift

protocol MaincVCDelegate {
    func getDish() -> Dish
}


class MainCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem! {
        didSet {
            deleteBarButton.isEnabled = false
            deleteBarButton.tintColor = .clear
        }
    }
    
    private var dishList: Results<Dish>!
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dishList = StorageManager.shared.realm.objects(Dish.self)
        createTempData()
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .systemYellow
        
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dishList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dishCell", for: indexPath) as! CollectionViewCell
        
        
        let dishList = dishList[indexPath.row]
        
        cell.configure(with: dishList)
        cell.isEditing = isEditing
        
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelectionDuringEditing = editing
        collectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: false)
        })
        collectionView.indexPathsForVisibleItems.forEach { (indexPath) in
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.isEditing = editing
        }
        
        addBarButton.isEnabled = !editing
        toggleButton(from: addBarButton, to: deleteBarButton)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addVC" {
            guard let addVC = segue.destination as? AddViewController else { return }
            addVC.delegate = self
        }
        
//        if segue.identifier == "detailsVC" {
//            guard let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems else { return }
//            guard let indexPath = indexPathsForSelectedItems.last else { return }
//
//            guard let detailsVC = segue.destination as? DetailsViewController else { return }
//
//            let dish = dishList[indexPath.row]
//            detailsVC.dish = dish
//        }
    }
    
    private func createTempData() {
        DataManager.shared.createTempData {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func deleteSelectedItems(_ sender: UIBarButtonItem) {
        
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            
            let items = selectedItems.map{$0.item}.sorted().reversed()
            for item in items {
                let dish = dishList[item]
                StorageManager.shared.delete(dish: dish)
            }
            collectionView.deleteItems(at: selectedItems)
            collectionView.reloadData()
            
        }
    }
    
}


extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let peddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - peddingWidth
        let itemWidth = availableWidth / itemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            let vc = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? DetailsViewController
            vc?.mainVCdelegate = self
            
            self.navigationController?.pushViewController(vc!, animated: true)
            
            
        }
    }
}


extension MainCollectionViewController {
    func toggleButton(from firstButton: UIBarButtonItem,to secondbuttom: UIBarButtonItem) {
        if firstButton.isEnabled {
            secondbuttom.isEnabled = false
            secondbuttom.tintColor = .clear
        } else {
            secondbuttom.isEnabled = true
            secondbuttom.tintColor = .systemRed
        }
    }
}



extension MainCollectionViewController: AddViewControllerDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView!.reloadData()
        }
    }
}

extension MainCollectionViewController: MaincVCDelegate {
    func getDish() -> Dish {
        let indexPathsForSelectedItems = collectionView.indexPathsForSelectedItems
        let indexPath = indexPathsForSelectedItems?.last
        let dish = dishList[indexPath?.row ?? 0]
        return dish
    }
    
    
}
