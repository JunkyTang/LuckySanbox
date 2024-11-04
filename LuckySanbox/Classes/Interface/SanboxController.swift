//
//  SanboxController.swift
//  LuckySanbox
//
//  Created by junky on 2024/10/12.
//

import UIKit
import Combine
import LuckyPropertyWrapper


public class SanboxController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindVM()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        $file.send(file)
    }
    
    
    private var cancellables: Set<AnyCancellable> = []
    
    deinit {
        cancellables.forEach{ $0.cancel() }
    }
    
    
    @CurrentValueSubjectProperty
    var file: Sanbox.File = .init(directory: .home)
    
    @PassthroughSubjectProperty
    var subFiles: [String] = []
    
    var funcForGetTargetFile: ((Sanbox.File) -> Void)?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: Bundle(for: Self.self))
    }
    
}


extension SanboxController {
    
    
    func setupUI() {
        
        tableView.register(UINib(nibName: "SanboxFileCell", bundle: Bundle(for: SanboxController.self)), forCellReuseIdentifier: "SanboxFileCell")
        
    }
    
    func bindVM() {
        
        
        $subFiles.receive(on: DispatchQueue.main).sink { [weak self] _ in
            guard let weakself = self else { return }
            weakself.tableView.reloadData()
        }.store(in: &cancellables)
        
        $file.receive(on: DispatchQueue.main).sink { [weak self] info in
            Sanbox.ExceptionHandler.hander {
                guard let weakself = self else { return }
                weakself.title = info.url.lastPathComponent
                weakself.subFiles = try FileManager.default.contentsOfDirectory(atPath: info.url.path)
            }
        }.store(in: &cancellables)
    }
    
}

extension SanboxController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subFiles.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SanboxFileCell", for: indexPath) as? SanboxFileCell else {
            fatalError()
        }
        cell.nameLab.text = subFiles[indexPath.row]
        cell.funcForLongPress = cellDidLongPress(cell:)
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = subFiles[indexPath.row]
        let url = file.url.appendingPathComponent(name)
        
        guard let file = url.converToFile() else { return }
        if file.file != nil {
            let preview = file.url
            let vc = UIDocumentInteractionController(url: preview)
            vc.delegate = self
            vc.presentPreview(animated: true)
            return
        }
        let vc = SanboxController()
        vc.file = file
        vc.funcForGetTargetFile = funcForGetTargetFile
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func cellDidLongPress(cell: SanboxFileCell) {
        
        guard let name = cell.nameLab.text
        else { return }
        
        let url = file.url.appendingPathComponent(name)
        guard let file = url.converToFile() else { return }
        
        
        if let funcForGetTargetFile = funcForGetTargetFile{
            funcForGetTargetFile(file)
            return
        }
        
        
        let menu = SanboxMenuView.loadFromXib()
        menu.file = file
        menu.show()
    }
    
}


extension SanboxController: UIDocumentInteractionControllerDelegate {
    
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
}
