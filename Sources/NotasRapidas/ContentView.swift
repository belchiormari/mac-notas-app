import SwiftUI

struct ContentView: View {
    @ObservedObject var store: NoteStore
    @State private var text: String = ""
    @State private var loadedURL: URL?
    @State private var saveWorkItem: DispatchWorkItem?

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List(selection: $store.selection) {
                    ForEach(store.notes) { note in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(note.preview)
                                .font(.headline)
                                .lineLimit(1)
                            Text(note.modifiedDate, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .tag(note.url)
                        .contextMenu {
                            Button("Mover para o Lixo") {
                                store.delete(note)
                            }
                        }
                    }
                }
                .listStyle(SidebarListStyle())

                Divider()

                Button(action: { store.createNote() }) {
                    Label("Nova nota", systemImage: "square.and.pencil")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(10)
                .keyboardShortcut("n", modifiers: .command)
            }
            .frame(minWidth: 220)

            Group {
                if loadedURL != nil {
                    TextEditor(text: $text)
                        .font(.system(.body, design: .monospaced))
                        .padding(6)
                        .onChange(of: text) { _ in scheduleSave() }
                } else {
                    Text("Selecione uma nota, ou crie uma nova")
                        .foregroundColor(.secondary)
                }
            }
            .frame(minWidth: 420, minHeight: 360)
        }
        .onChange(of: store.selection) { newValue in
            flushSave()
            loadedURL = newValue
            text = newValue.flatMap { try? String(contentsOf: $0, encoding: .utf8) } ?? ""
        }
    }

    private func scheduleSave() {
        saveWorkItem?.cancel()
        let url = loadedURL
        let currentText = text
        let item = DispatchWorkItem {
            guard let url = url else { return }
            try? currentText.write(to: url, atomically: true, encoding: .utf8)
            store.reload()
        }
        saveWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
    }

    private func flushSave() {
        saveWorkItem?.perform()
        saveWorkItem?.cancel()
        saveWorkItem = nil
    }
}
