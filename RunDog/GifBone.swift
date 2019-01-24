//
//  GifBone.swift
//  RunDog
//
//  Created by 垰 尚太朗 on 2019/01/24.
//  Copyright © 2019 垰 尚太朗. All rights reserved.
//

import Cocoa

class GifBone {
    var imageName: String?

    let statusButton: NSStatusBarButton

    init(statusButton: NSStatusBarButton) {
        self.statusButton = statusButton
    }

    func update() {
        statusButton.image = NSImage(named: imageName!)
    }
}
