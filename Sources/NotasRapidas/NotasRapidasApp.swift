import SwiftUI

@main
struct NotasRapidasApp: App {
    @StateObject private var store = NoteStore()

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
