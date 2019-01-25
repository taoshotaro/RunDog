//
//  AppDelegate.swift
//  RunDog
//
//  Created by 垰 尚太朗 on 2019/01/24.
//  Copyright © 2019 垰 尚太朗. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var gifBone: GifBone?

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        if let button = statusItem.button {
            button.imageScaling = .scaleProportionallyDown
            gifBone = GifBone(statusButton: button, imageName: "inu")
            gifBone?.start()
        }

        constructMenu()
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func getURl() {
        let alert = NSAlert()
        alert.messageText = "Insert GIF URL"
        alert.alertStyle = .critical
//        urlTextField.delegate = self
//        urlTextField.stringValue = ""
        alert.accessoryView = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        let gifs = ["blinking", "james", "rap", "think", "parrot"]
        let aleartGifBone = GifBone(alert: alert, imageName: gifs[Int.random(in: 0...4)])
        aleartGifBone.start()
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let responseTag = alert.runModal()
        if responseTag.rawValue == 1000 {
            guard let textField = alert.accessoryView as? NSTextField else { return }
            self.gifBone?.imageURL = textField.stringValue
        } else if responseTag.rawValue == 1001 {
            print("Cancel")
        }
        aleartGifBone.stop()
    }

    func constructMenu() {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Add From URL", action: #selector(getURl), keyEquivalent: "u"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }

}

