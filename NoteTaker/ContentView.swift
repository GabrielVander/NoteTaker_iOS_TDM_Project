//
//  ContentView.swift
//  NoteTaker
//
//  Created by Gabriel on 30/11/22.
//
//

import SwiftUI
import CoreData

struct Note: Identifiable {
    let id = UUID()
    var title: String
    var content: String
}

struct ContentView: View {
    @State private var editMode = EditMode.inactive
    @State private var notes: [Note] = [
        Note(title: "Note 1", content: "To Be Or Not To Be"),
        Note(title: "Note 2", content: "That Is The Question!")
    ]

    var body: some View {
        Text("Note Taker")
                .font(.title)

        NavigationView {

            List {
                if (notes.isEmpty) {
                    VStack {
                        Text("No notes... Write some!")
                                .font(.title2)
                        Button(action: addItem) {
                            Text("New")
                        }
                                .buttonStyle(.borderedProminent)
                    }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(notes) { note in
                        HStack {
                            Text(note.title).foregroundColor(Color.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 7)
                                    .foregroundColor(Color.white)
                        }
                                .background(
                                        NavigationLink(destination: {
                                            NoteDisplay(note: note, onSave: { new in
                                                let index = notes.firstIndex(where: { n in n.id == note.id })
                                                notes.remove(at: index ?? 0)
                                                notes.insert(new, at: notes.startIndex)
                                            })
                                        }) {
                                        }
                                                .opacity(0)
                                )
                    }
                            .onDelete(perform: deleteItems)
                            .listRowBackground(Color.blue)
                            .listRowSeparatorTint(.white)
                }

            }
                    .listStyle(.insetGrouped)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if (!notes.isEmpty) {
                                EditButton()
                            }
                        }
                        ToolbarItem {
                            Button(action: addItem) {
                                Label("Add Item", systemImage: "plus")
                            }
                        }
                    }
                    .environment(\.editMode, $editMode)
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newNote = Note(title: "New Note", content: "I'm an avocado!")
            notes.append(newNote)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { i in
                notes.remove(at: i)
            }
        }
        if (notes.isEmpty) {
            editMode = EditMode.inactive
        }
    }
}

struct NoteDisplay: View {
    @Environment(\.dismiss) var dismiss

    private var onSave: (Note) -> Void = { _ in
    }
    @State private var note: Note

    init(note: Note, onSave: @escaping (Note) -> Void) {
        self._note = State(initialValue: note)
        self.onSave = onSave
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $note.title)
                }
                Section(header: Text("Note")) {
                    TextField("Content", text: $note.content)
                }
                Section {
                    Button(action: {
                        if (validateInput()) {
                            onSave(note)
                            dismiss()
                        }
                    }) {
                        Text("Save")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    }
                }
            }
                    .background(.blue)
        }
    }

    private func validateInput() -> Bool {
        !note.title.isEmpty && !note.content.isEmpty
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
