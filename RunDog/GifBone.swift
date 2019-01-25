//
//  GifBone.swift
//  RunDog
//
//  Created by 垰 尚太朗 on 2019/01/24.
//  Copyright © 2019 垰 尚太朗. All rights reserved.
//

import Cocoa

class GifBone {
    
    private var timer: Timer?
    private var gif: GifInfo?
    private var frameAt: Int = 0
    private var statusButton: NSStatusBarButton?
    private var alert: NSAlert?
    var imageName: String {
        didSet {
            reloadImage()
        }
    }
    var imageURL: URL? {
        didSet {
            reloadFromURL()
        }
    }

    init(statusButton: NSStatusBarButton, imageName: String) {
        self.statusButton = statusButton
        self.imageName = imageName
        reloadImage()
    }
    
    init(alert: NSAlert, imageName: String) {
        self.alert = alert
        self.imageName = imageName
        print(imageName)
        reloadImage()
    }
    
    private func reloadImage() {
        stop()
        guard let urlPath = Bundle.main.url(forResource: imageName, withExtension: "gif") else { return }
        guard let info = Decoder().decode(gifUrl: urlPath) else { return }
        gif = info
        start()
    }
    
    private func reloadFromURL() {
        stop()
        if let imageURL = imageURL {
            guard let info = Decoder().decode(gifUrl: imageURL) else { return }
            gif = info
        }
        start()
    }
    
    func start() {
        if let gif = gif {
            timer = Timer.scheduledTimer(timeInterval: gif.frameDuration, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    func stop() {
        timer?.invalidate()
    }

    @objc private func update() {
        if let gif = gif {
            if let statusButton = statusButton {
                DispatchQueue.main.async {
                    statusButton.image = gif.images[self.frameAt % Int(gif.images.count)]
                }
            }
            if let alert = alert {
                DispatchQueue.main.async {
                    alert.icon = gif.images[self.frameAt % Int(gif.images.count)]
                }
            }
            frameAt += 1
        }
    }
    
    deinit {
        print("DEEEEEE")
    }
}
