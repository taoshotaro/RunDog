import Cocoa

class GifBone {
    
    private var gifTimer: Timer?
    private var cpuTimer: Timer?
    private var gif: GifInfo?
    private var frameAt: Int = 0
    private var statusButton: NSStatusBarButton?
    private var alert: NSAlert?
    private var system: System
    private var cpuPercentage: Double = 1.0

    var imageName: String {
        didSet {
            reloadImage()
        }
    }
    var imageURL: String? {
        didSet {
            downloadGIF(url: imageURL!)
        }
    }
    private var localURL: URL? {
        didSet {
            reloadFromURL()
        }
    }

    init(statusButton: NSStatusBarButton, imageName: String) {
        self.statusButton = statusButton
        self.imageName = imageName
        self.system = System()
        reloadCPUUsage()
        cpuTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(reloadCPUUsage), userInfo: nil, repeats: true)
        reloadImage()
    }
    
    init(alert: NSAlert, imageName: String) {
        self.alert = alert
        self.imageName = imageName
        self.system = System()
        reloadCPUUsage()
        cpuTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(reloadCPUUsage), userInfo: nil, repeats: true)
        reloadImage()
    }
    
    private func downloadGIF(url: String) {
        if url.isGIF() && url.isURL() {
            let downloader = Downloader(url: URL(string: url)!)
            downloader.download(compleation: { downloadedGifURL in
                self.localURL = downloadedGifURL
            }) { error in
                print(error)
            }
        }
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
        if let localURL = localURL {
            guard let info = Decoder().decode(gifUrl: localURL) else { return }
            gif = info
        }
        start()
    }
    
    func start() {
        if let gif = gif {
            gifTimer?.invalidate()
            let interval: TimeInterval = gif.frameDuration * cpuPercentage
            gifTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            RunLoop.current.add(gifTimer!, forMode: .common)
        }
    }

    @objc func reloadCPUUsage() {
        let (systemCPU, userCPU, _, _) = system.usageCPU()
        if !systemCPU.isNaN && !userCPU.isNaN {
            let center = (userCPU + systemCPU - 50)
            let toone = center / 50
            let revert = toone * -1
            cpuPercentage = pow(2, revert)
            if center.isNaN || toone.isNaN || revert.isNaN || cpuPercentage.isNaN {
                print(systemCPU)
                print(userCPU)
            }
            start()
        }
    }

    func stop() {
        gifTimer?.invalidate()
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
