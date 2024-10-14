//
//  SanboxFileCell.swift
//  LuckySanbox
//
//  Created by junky on 2024/10/12.
//

import UIKit
import Combine

class SanboxFileCell: UITableViewCell {

    
    @IBOutlet weak var nameLab: UILabel!
    
    
    @objc func didLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            funcForLongPress?(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let ges = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        addGestureRecognizer(ges)
        
    }

    var funcForLongPress: ((SanboxFileCell) -> Void)?
    
    
}
