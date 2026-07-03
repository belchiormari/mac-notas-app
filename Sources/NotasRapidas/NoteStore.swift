import Foundation

struct NoteFile: Identifiable, Hashable {
    let url: URL
    var modifiedDate: Date
    var preview: String

    var id: URL { url }
}

final class NoteStore: ObservableObject {
    @Published var notes: [NoteFile] = []
    @Published var selection: URL?

    let notesDirectory: URL = {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = documents.appendingPathComponent("Notas Rápidas", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    init() {
        reload()
    }

    func reload() {
        let files = (try? FileManager.default.contentsOfDirectory(
            at: notesDirectory,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: [.skipsHiddenFiles]
        )) ?? []

        notes = files
            .filter { $0.pathExtension.lowercased() == "txt" }
            .map { url -> NoteFile in
                let modified = (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? .distantPast
                let text = (try? String(contentsOf: url, encoding: .utf8)) ?? ""
                return NoteFile(url: url, modifiedDate: modified, preview: NoteStore.preview(from: text))
            }
            .sorted { $0.modifiedDate > $1.modifiedDate }
    }

    static func preview(from text: String) -> String {
        let firstLine = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false).first.map(String.init) ?? ""
        let trimmed = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Nova nota" : trimmed
    }

    @discardableResult
    func createNote() -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        let url = notesDirectory.appendingPathComponent("Nota \(formatter.string(from: Date())).txt")
        try? "".write(to: url, atomically: true, encoding: .utf8)
        reload()
        selection = url
        return url
    }

    func delete(_ note: NoteFile) {
        try? FileManager.default.trashItem(at: note.url, resultingItemURL: nil)
        if selection == note.url {
            selection = nil
        }
        reload()
    }
}
