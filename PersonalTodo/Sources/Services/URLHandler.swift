import Foundation

/// Handles personaltodo:// URL scheme for external task creation
///
/// Supported URLs:
///   personaltodo://add?title=Task+name&label=ClientName
///   personaltodo://add?title=Task+name  (label is optional)
///
/// Example usage from terminal:
///   open "personaltodo://add?title=Review+proposal&label=Acme"
///
/// Example from a script adding multiple tasks:
///   open "personaltodo://add?title=Check+emails&label=Flixr"
///   open "personaltodo://add?title=Update+roadmap&label=Nanoclaw"
///
class URLHandler: NSObject {
    static let shared = URLHandler()
    var store: TaskStore?

    @objc func handleURL(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue,
              let url = URL(string: urlString),
              url.scheme == "personaltodo" else {
            return
        }

        switch url.host {
        case "add":
            handleAdd(url: url)
        default:
            break
        }
    }

    private func handleAdd(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let title = components.queryItems?.first(where: { $0.name == "title" })?.value,
              !title.isEmpty else {
            return
        }

        let label = components.queryItems?.first(where: { $0.name == "label" })?.value ?? ""

        DispatchQueue.main.async {
            self.store?.addTask(title: title, label: label)
        }
    }
}
