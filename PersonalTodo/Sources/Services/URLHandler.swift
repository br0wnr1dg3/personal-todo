import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleGetURL(_:withReplyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }

    @objc func handleGetURL(_ event: NSAppleEventDescriptor, withReplyEvent replyEvent: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue,
              let url = URL(string: urlString),
              url.scheme == "personaltodo", url.host == "add",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let title = components.queryItems?.first(where: { $0.name == "title" })?.value,
              !title.isEmpty else {
            return
        }
        let label = components.queryItems?.first(where: { $0.name == "label" })?.value?.replacingOccurrences(of: "+", with: " ") ?? ""
        let decodedTitle = title.replacingOccurrences(of: "+", with: " ")
        DispatchQueue.main.async {
            TaskStore.shared?.addTask(title: decodedTitle, label: label)
        }
    }
}
