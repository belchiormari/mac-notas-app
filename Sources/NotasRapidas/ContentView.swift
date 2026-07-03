import SwiftUI

struct ContentView: View {
    @Binding var document: TextDocument

    var body: some View {
        TextEditor(text: $document.text)
            .font(.system(.body, design: .monospaced))
            .padding(6)
            .frame(minWidth: 480, minHeight: 360)
    }
}
