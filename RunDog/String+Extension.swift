//
//  String+Extention.swift
//  RunDog
//
//  Created by 垰尚太朗 on 2019/01/25.
//  Copyright © 2019 垰 尚太朗. All rights reserved.
//

extension String {
    
    public func isImage() -> Bool {
        // Add here your image formats.
        let imageFormats = ["jpg", "jpeg", "png", "gif"]
        
        if let ext = self.getExtension() {
            return imageFormats.contains(ext)
        }
        
        return false
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
