//
//  String+Extention.swift
//  RunDog
//
//  Created by 垰尚太朗 on 2019/01/25.
//  Copyright © 2019 垰 尚太朗. All rights reserved.
//

import Cocoa

extension String {
    
    public func isGIF() -> Bool {
        print(self)
        let ext = String(self.suffix(4))
        print("EXT", ext)
        return ext == ".gif" || ext == ".GIF"
    }
    
    public func getExtension() -> String? {
        let ext = (self as NSString).pathExtension
        
        if ext.isEmpty {
            return nil
        }
        
        return ext
    }
    
    public func isURL() -> Bool {
        return URL(string: self) != nil
    }
    
}
