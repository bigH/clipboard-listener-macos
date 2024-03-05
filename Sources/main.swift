import Cocoa

class PasteboardWatcher : NSObject {
    private let pasteboard = NSPasteboard.general
    private var changeCount : Int
    private var timer: Timer?

    override init() {
        changeCount = pasteboard.changeCount
        super.init()
    }

    func startPolling () {
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.05,
            repeats: true,
            block: { (t: Timer) -> Void in
                if self.pasteboard.changeCount != self.changeCount {
                    if let copiedString = self.pasteboard.string(forType: .string) {
                        print(copiedString)
                        self.changeCount = self.pasteboard.changeCount
                    }
                }
            }
        )
    }
}

let watcher = PasteboardWatcher()
watcher.startPolling()

RunLoop.main.run()

