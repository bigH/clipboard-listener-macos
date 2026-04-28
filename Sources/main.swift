import Cocoa

struct Options {
    let exitOnFirstCopy: Bool

    static func parse(arguments: [String]) -> Options {
        Options(exitOnFirstCopy: arguments.dropFirst().contains("--exit-on-first-copy"))
    }
}

final class PasteboardWatcher: NSObject {
    private let pasteboard = NSPasteboard.general
    private let exitOnFirstCopy: Bool
    private var changeCount: Int
    private var timer: Timer?

    init(exitOnFirstCopy: Bool) {
        self.exitOnFirstCopy = exitOnFirstCopy
        self.changeCount = pasteboard.changeCount
        super.init()
    }

    func startPolling() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.05,
            repeats: true,
            block: { [weak self] (_: Timer) -> Void in
                self?.handlePasteboardChange()
            }
        )
    }

    private func handlePasteboardChange() {
        let currentChangeCount = pasteboard.changeCount
        guard currentChangeCount != changeCount else { return }

        changeCount = currentChangeCount

        guard let copiedString = pasteboard.string(forType: .string) else { return }

        print(copiedString)

        if exitOnFirstCopy {
            Foundation.exit(EXIT_SUCCESS)
        }
    }
}

let options = Options.parse(arguments: CommandLine.arguments)
let watcher = PasteboardWatcher(exitOnFirstCopy: options.exitOnFirstCopy)
watcher.startPolling()

RunLoop.main.run()
