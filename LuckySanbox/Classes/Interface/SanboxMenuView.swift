//
//  SanboxMenuView.swift
//  LuckySanbox
//
//  Created by junky on 2024/10/14.
//

import UIKit
import LuckyPop
import LuckyIB

final class SanboxMenuView: UIView {

    var navi: UINavigationController?
    
    var file: Sanbox.File? {
        didSet {
            reload()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        navi = UINavigationController()
        addSubview(navi!.view)
        navi!.view.snp.makeConstraints { make in
            make.edges.equalTo(0)
            make.height.equalTo(300)
        }
    }
    
    func reload() {
        
        
        let vc = SanboxMenuController()
        vc.file = file
        navi?.pushViewController(vc, animated: true)
    }

}

extension SanboxMenuView: SheetPopable, IBLoadable {}

