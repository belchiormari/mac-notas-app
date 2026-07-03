import SwiftUI

@main
struct NotasRapidasApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: TextDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
