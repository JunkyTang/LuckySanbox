//
//  Sanbox.Model.swift
//  SanboxManagerDemo
//
//  Created by junky on 2024/10/12.
//

import Foundation


public extension Sanbox {
    
    enum Directory {
        case home
        case document
        case temp
        case library
        case cache
        
        
        public var url: URL {
            let result: URL
            switch self {
            case .home:
                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                result = url.deletingLastPathComponent()
            case .document:
                result = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            case .temp:
                result = FileManager.default.temporaryDirectory
            case .library:
                result = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
            case .cache:
                result = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            }
            return result
        }
        
        public static func fromUrl(url: URL?) -> Directory? {
            guard let url = url else { return nil }
            
            let list: [Directory] = [.cache, .temp, .library, .document, .home]
            
            for dir in list {
                if url.absoluteString.hasPrefix(dir.url.absoluteString) {
                    return dir
                }
            }
            return nil
        }
        
        
    }
    
    
    class File {
        
        public var directory: Directory
        
        public var folderPath: String?
        
        public var file: String?
        
        public init(directory: Directory, folderPath: String? = nil, file: String? = nil) {
            self.directory = directory
            self.folderPath = folderPath
            self.file = file
        }
        
    }
    
    
}

public extension Sanbox.File {
    
    var url: URL {
        var result = directory.url
        if let folderPath = folderPath {
            result.appendPathComponent(folderPath, isDirectory: true)
        }
        if let file = file {
            result.appendPathComponent(file, isDirectory: false)
        }
        return result
    }
    
    
    var isExist: Bool {
        let result = FileManager.default.fileExists(atPath: url.path)
        return result
    }

}


public extension Sanbox.File {
    
    func write(data: Data) throws {
        guard let _ = file else { throw Sanbox.Exception(msg: "file name doesnt exist") }
        let targetUrl = url
        let folderUrl = targetUrl.deletingLastPathComponent()
        
        let fileManager = FileManager.default
        try fileManager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
        try data.write(to: targetUrl)
    }
    
    
    func delete() throws {
        let manager = FileManager.default
        let target = url

        try manager.removeItem(at: target)
    }
    
    func copyTo(under folder: Sanbox.File) throws {
        
        let manager = FileManager.default
        folder.file = nil
        let target = folder.url
        
        try manager.copyItem(at: url, to: target)
    }
    
    func moveTo(under folder: Sanbox.File) throws {
        let manager = FileManager.default
        folder.file = file
        let target = folder.url
        
        try manager.moveItem(at: url, to: target)
    }
    
}


public extension URL {
    
    func converToFile() -> Sanbox.File? {
        
        guard let dir = Sanbox.Directory.fromUrl(url: self) else { return nil }
        
        var isDir: ObjCBool = false
        let exist = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        if !exist {
            return nil
        }
        
        var fileName: String?
        var folderPath: String? = absoluteString.replacingOccurrences(of: dir.url.absoluteString, with: "")
        if folderPath!.hasPrefix("/") {
            folderPath?.removeFirst()
        }
        if isDir.boolValue == false {
            fileName = lastPathComponent
            let tmp = deletingLastPathComponent()
            folderPath = tmp.absoluteString.replacingOccurrences(of: dir.url.absoluteString, with: "")
        }

        return .init(directory: dir, folderPath: folderPath, file: fileName)
    }
}

