//
//  Sanbox.Exception.swift
//  LuckySanbox
//
//  Created by junky on 2024/10/12.
//

import Foundation

public extension Sanbox {
    
    
    struct ExceptionHandler {
        
        
        public static func hander(_ throwable: () throws -> Void) {
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
        
        public private(set) var msg: String
        
        public init(msg: String) {
            self.msg = msg
        }
    }
    
}
