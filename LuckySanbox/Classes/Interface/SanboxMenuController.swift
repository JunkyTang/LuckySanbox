//
//  SanboxMenuController.swift
//  LuckySanbox
//
//  Created by junky on 2024/10/14.
//

import UIKit

class SanboxMenuController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    init() {
        super.init(nibName: "SanboxMenuController", bundle: Bundle(for: SanboxMenuController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        bindVM()
    }
    
    var file: Sanbox.File?
    var items: [String] = ["delete", "move to", "copy to"]
    
}


extension SanboxMenuController {
    
    func setupUI() {
        title = "menu"
        
        tableView.register(UINib(nibName: "SanboxFileCell", bundle: Bundle(for: SanboxFileCell.self)), forCellReuseIdentifier: "SanboxFileCell")
    }
    
    func bindVM() {
        
    }
}

extension SanboxMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SanboxFileCell", for: indexPath) as? SanboxFileCell else { fatalError() }
        cell.nameLab.text = items[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            delete()
        } else if indexPath.row == 1 {
            let vc = SanboxController()
            vc.funcForGetTargetFile = { [weak self] file in
                guard let weakself = self else { return }
                weakself.moveTo(under: file)
            }
            navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = SanboxController()
            vc.funcForGetTargetFile = { [weak self] file in
                guard let weakself = self else { return }
                weakself.copyTo(under: file)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    func delete() {
        
        Sanbox.ExceptionHandler.hander {
            guard let file = file else { throw Sanbox.Exception(msg: "target file can not be nil") }
            try file.delete()
            
            throw Sanbox.Exception(msg: "delete success")
        }
    }
    
    func moveTo(under folder: Sanbox.File) {
        
        Sanbox.ExceptionHandler.hander {
            guard let file = file else { throw Sanbox.Exception(msg: "target file can not be nil") }
            try file.moveTo(under: folder)
            
            throw Sanbox.Exception(msg: "move success")
        }
    }
    
    func copyTo(under folder: Sanbox.File) {
        
        Sanbox.ExceptionHandler.hander {
            guard let file = file else { throw Sanbox.Exception(msg: "target file can not be nil") }
            try file.copyTo(under: folder)
            
            throw Sanbox.Exception(msg: "copy success")
        }
    }
}
