//
//  OrderSummaryTableViewCell.swift
//  CafeManager_cobsccomp192p-047_cw
//
//  Created by Tiny Pahattuge on 2021-04-30.
//

import UIKit

class OrderSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblorderID: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
    
    class var reuseIdentifier: String {
        return "OrderSummaryCellReusable"
    }
    
    class var nibName: String {
        return "OrderSummaryTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configXIB(order: Order) {
        lblorderID.text = order.orderID
        
        var foodNames: String = ""
        var orderInfo: String = ""
        var totalAmount: Double = 0
        
        for item in order.orderItems {
            print(item.item_name)
            foodNames += "\n\(item.item_name)"
            orderInfo += "\n1 X \(item.price) LKR"
            totalAmount += 1 * item.price
        }
        
        lblItems.text = foodNames
        lblQty.text = orderInfo
        lblOrderTotal.text = "Total : \(totalAmount)"
    }
    
}
