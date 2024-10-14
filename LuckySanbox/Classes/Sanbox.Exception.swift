//
//  Sanbox.Exception.swift
//  LuckySanbox
//
//  Created by junky on 2024/10/12.
//

import Foundation

extension Sanbox {
    
    
    struct ExceptionHandler {
        
        
        static func hander(_ throwable: () throws -> Void) {
            do {
                try throwable()
            } catch {
                funcForCatchException(error)
            }
        }
        
        static var funcForCatchException: (Error) -> Void = { e in
            print(e.localizedDescription)
        }
        
    }
    
    struct Exception: Error {
        
        var msg: String
        
        init(msg: String) {
            self.msg = msg
        }
    }
    
}
