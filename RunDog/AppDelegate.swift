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
        gifBone.stop()
    }
    
    func downloadGIF(url: String) {
        let withoutExt = URL(string: url)!.deletingPathExtension()
        let name = withoutExt.lastPathComponent
        if url.isGIF() && url.isURL() {
            let url  = URL(string: url)!
            let task = URLSession.shared.downloadTask(with: url) { location, response, error in
                if error != nil {
                    
                } else {
                    let fileManager = FileManager.default
                    guard let folder = fileManager.urls(for: .applicationSupportDirectory,
                                                        in: .userDomainMask).first else { return }
                    let imageFolder = folder.appendingPathComponent("RunDog").appendingPathComponent("images")
                    var isDirectory: ObjCBool = false
                    let folderExists = fileManager.fileExists(atPath: imageFolder.path,
                                                              isDirectory: &isDirectory)
                    if !folderExists || !isDirectory.boolValue {
                        do {
                            // 4
                            try fileManager.createDirectory(at: imageFolder,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                        } catch {
                            return
                        }
                    }
                    guard let atPath = location else { return }
                    guard let suggestedFilename = response?.suggestedFilename else { return }
                    let toPath = imageFolder.appendingPathComponent(suggestedFilename)
                    do {
                        try FileManager.default.moveItem(atPath: atPath.path, toPath: toPath.path)
                    } catch { error
                        print(error)
                        return
                    }
                    self.gifBone?.imageURL = toPath
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

