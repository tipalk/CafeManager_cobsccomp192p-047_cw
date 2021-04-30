//
//  CategoryViewController.swift
//  CafeManager_cobsccomp192p-047_cw
//
//  Created by Tiny Pahattuge on 2021-04-30.
//

import UIKit
import FirebaseDatabase
import Loaf

class CategoryViewController: UIViewController {
    
    let databaseReference = Database.database().reference()
    
    var categoryList: [Category] = []

    @IBOutlet weak var txtCategoryName: UITextField!
    @IBOutlet weak var tblCategory: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCategory.register(UINib(nibName: CategoryInfoTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: CategoryInfoTableViewCell.reuseIdentifier)
        refreshCategories()
        // Do any additional setup after loading the view.
    }

    @IBAction func onAddCategoryPresses(_ sender: UIButton) {
        if let name = txtCategoryName.text {
            adddCategory(name: name)
        } else {
            Loaf("Enter a category name", state: .error, sender: self).show()
        }
    }
}

extension CategoryViewController {
    func adddCategory(name: String) {
        databaseReference
            .child("categories")
            .childByAutoId()
            .child("name")
            .setValue(name) {
                error, ref in
                if let error = error {
                    Loaf(error.localizedDescription, state: .error, sender: self).show()
                } else {
                    Loaf("Category Created", state: .success, sender: self).show()
                    self.refreshCategories()
                }
            }
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
                    
                    self.tblCategory.reloadData()
                }
            })
    }
    
    func removeCategory(category: Category) {
        databaseReference
            .child("categories")
            .child(category.categoryID)
            .removeValue() {
                error, databaseReference in
                if error != nil {
                    Loaf("Could not remove category", state: .error, sender: self).show()
                } else {
                    Loaf("Category Removed", state: .success, sender: self).show()
                    self.refreshCategories()
                }
            }
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCategory.dequeueReusableCell(withIdentifier: CategoryInfoTableViewCell.reuseIdentifier, for: indexPath) as! CategoryInfoTableViewCell
        cell.selectionStyle = .none
        cell.configXIB(category: self.categoryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeCategory(category: categoryList[indexPath.row])
            refreshCategories()
        }
    }
}
