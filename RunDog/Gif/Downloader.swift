import Cocoa
import Foundation

public class Downloader {
    
    private let url: URL
    private var downloadTask: URLSessionDownloadTask?
    
    public init(url: URL) {
        self.url = url
    }
    
    public func download(compleation: @escaping (URL) -> Void, failed: @escaping (Error) -> Void) {
        downloadTask = URLSession.shared.downloadTask(with: url) { location, response, error in
            if let error = error {
                failed(error)
                return
            } else {
                let fileManager = FileManager.default
                guard let folder = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return }
                let imageFolder = folder.appendingPathComponent("RunDog").appendingPathComponent("images")
                var isDirectory: ObjCBool = false
                let folderExists = fileManager.fileExists(atPath: imageFolder.path, isDirectory: &isDirectory)
                guard let atPath = location else { return }
                guard let suggestedFilename = response?.suggestedFilename else { return }
                let toPath = imageFolder.appendingPathComponent(suggestedFilename)
                
                if !folderExists || !isDirectory.boolValue {
                    do {
                        try fileManager.createDirectory(at: imageFolder, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        failed(error)
                        return
                    }
                }
                
                do {
                    try FileManager.default.moveItem(atPath: atPath.path, toPath: toPath.path)
                } catch {
                    failed(error)
                    return
                }
                compleation(toPath)
            }
        }
        downloadTask?.resume()
    }
}
