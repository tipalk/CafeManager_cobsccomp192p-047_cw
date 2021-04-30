//
//  PreviewViewController.swift
//  CafeManager_cobsccomp192p-047_cw
//
//  Created by Tiny Pahattuge on 2021-04-30.
//

import UIKit
import Firebase
import Loaf

class PreviewViewController: UIViewController {

    @IBOutlet weak var tblFoodItems: UITableView!
    @IBOutlet weak var collectionViewCategories: UICollectionView!
    
    let databaseReference = Database.database().reference()
    
    var categoryList: [Category] = []
    var foodItemList: [FoodItem] = []
    var filteredFood: [FoodItem] = []
    
    var selectedCategoryIndex = 0
    var selectedFoodIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionViewNib = UINib(nibName: CategoryCollectionViewCell.nibName, bundle: nil)
        collectionViewCategories.register(collectionViewNib, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.collectionViewCategories?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 80, height: 30)
        }
        
        tblFoodItems.register(UINib(nibName: FoodItemTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FoodItemTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshCategories()
        refreshFood()
    }

}

extension PreviewViewController {
    
    func filterFood(category: Category) {
        filteredFood = foodItemList.filter {$0.foodCategory == category.categoryName}
        tblFoodItems.reloadData()
    }
    
    func refreshCategories() {
        self.categoryList.removeAll()
        databaseReference
            .child("categories")
            .observeSingleEvent(of: .value, with: {
                snapshot in
                if snapshot.hasChildren() {
                    guard let data = snapshot.value as? [String: Any] else {
                        return
                    }
                    
                    for category in data {
                        if let categoryInfo = category.value as? [String: String] {
                            self.categoryList.append(Category(categoryID: category.key, categoryName: categoryInfo["name"]!))
                        }
                    }
                    
                    self.collectionViewCategories.reloadData()
                }
            })
    }
    
    func changeFoodStatus(foodItem: FoodItem, status: Bool) {
        databaseReference
            .child("foodItems")
            .child(foodItem.foodItemID)
            .child("isActive")
            .setValue(status) {
                error, reference in
                
                if error != nil {
                    Loaf("Food status not changed", state: .error, sender: self).show()
                } else {
                    Loaf("Food status changed", state: .success, sender: self).show()
                }
            }
    }
    
    func refreshFood() {
        foodItemList.removeAll()
        filteredFood.removeAll()
        
        databaseReference
            .child("foodItems")
            .observeSingleEvent(of: .value, with: {
                snapshot in
                if snapshot.hasChildren() {
                    guard let data = snapshot.value as? [String: Any] else {
                        NSLog("Could not parse data")
                        return
                    }
                    
                    for food in data {
                        if let foodInfo = food.value as? [String: Any] {
                            self.foodItemList.append(
                                FoodItem(
                                    foodItemID: food.key,
                                    foodName: foodInfo["food_name"] as! String,
                                    foodDescription: foodInfo["description"] as! String,
                                    foodPrice: foodInfo["price"] as! Double,
                                    discount: foodInfo["discount"] as! Int,
                                    foodImgRes: foodInfo["imgage"] as! String,
                                    foodCategory: foodInfo["category"] as! String,
                                    isActive: foodInfo["isActive"] as! Bool))
                        }
                    }
                    
                    self.filteredFood.append(contentsOf: self.foodItemList)
                    self.tblFoodItems.reloadData()
                }
            })
    }
}

extension PreviewViewController: UITableViewDataSource, UITableViewDelegate, FoodItemCellActions {
    func onFoodItemStatusChanged(foodItem: FoodItem, status: Bool) {
        self.changeFoodStatus(foodItem: foodItem, status: status)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFood.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFoodItems.dequeueReusableCell(withIdentifier: FoodItemTableViewCell.reuseIdentifier, for: indexPath) as! FoodItemTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configXIB(foodItem: filteredFood[indexPath.row], index: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFoodIndex = indexPath.row
    }
}

extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionViewCategories.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier,
                                                                   for: indexPath) as? CategoryCollectionViewCell {
            cell.confixXIB(category: categoryList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        UIView.transition(with: collectionViewCategories, duration: 0.3, options: .transitionCrossDissolve, animations: {self.collectionViewCategories.reloadData()}, completion: nil)
        
        filterFood(category: categoryList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CategoryCollectionViewCell = Bundle.main.loadNibNamed(CategoryCollectionViewCell.nibName,
                                                                owner: self,
                                                                options: nil)?.first as? CategoryCollectionViewCell else {
            return CGSize.zero
        }
        cell.confixXIB(category: categoryList[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 30)
    }
}
