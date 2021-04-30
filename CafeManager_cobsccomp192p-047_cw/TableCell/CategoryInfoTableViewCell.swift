//
//  CategoryInfoTableViewCell.swift
//  CafeManagerTest
//
//  Created by Hishara Dilshan on 2021-04-30.
//

import UIKit

class CategoryInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCategoryName: UILabel!
    
    class var reuseIdentifier: String {
        return "CategoryInfoReusable"
    }
    
    class var nibName: String {
        return "CategoryInfoTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configXIB(category: Category) {
        lblCategoryName.text = category.categoryName
    }
    
}
