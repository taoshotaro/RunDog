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
    let urlTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
    var urlInput: String = ""
    var gifBone: GifBone?

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        if let button = statusItem.button {
            button.imageScaling = .scaleProportionallyDown
            gifBone = GifBone(statusButton: button, imageName: "parrot")
            gifBone?.start()
//            button.action = #selector(printQuote)
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
        urlTextField.delegate = self
        alert.accessoryView = urlTextField
        let gifs = ["blinking", "james", "rap", "think", "parrot"]
        let gifBone = GifBone(alert: alert, imageName: gifs[Int.random(in: 0...4)])
        gifBone.start()
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let responseTag = alert.runModal()
        if responseTag.rawValue == 1000 {
            downloadGIF(url: urlInput)
        } else if responseTag.rawValue == 1001 {
            print("Cancel")
        }
    }
    
    func downloadGIF(url: String) {
        if url.isGIF() && url.isURL() {
            let url  = URL(string: url)!
            let task = URLSession.shared.downloadTask(with: url) { location, response, error in
                if error != nil {
                    print(error)
                } else {
                    self.gifBone?.imageURL = location
                }
            }
            task.resume()
        }
    }

    func constructMenu() {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Add From URL", action: #selector(getURl), keyEquivalent: "u"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }

}

extension AppDelegate: NSTextFieldDelegate {
    
    func controlTextDidEndEditing(_ obj: Notification) {
        urlInput = urlTextField.stringValue
    }
    
}

