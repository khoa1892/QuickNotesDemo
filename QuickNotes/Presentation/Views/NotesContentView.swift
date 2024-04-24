//
//  ContentView.swift
//  QuickNotes
//
//  Created by Khoa Mai on 17/4/24.
//

import SwiftUI
import FirebaseDatabase
import Combine

struct NotesContentView: View {
    
    var viewModel: NoteListViewModel
    var output: NoteListViewModel.Output
    @State private var notes: [NoteInfo] = []
    @State private var showAlert: Bool = false
    @State private var showUserAlert: Bool = false
    
    private var loadViewTrigger = PassthroughSubject<Void, Never>()
    private var loadNotesTrigger = PassthroughSubject<LoadType, Never>()
    private var addNoteTrigger = PassthroughSubject<String, Never>()
    private var createUserTrigger = PassthroughSubject<String, Never>()
    private var loadUserInfoTrigger = PassthroughSubject<Void, Never>()
    
    @State private var showingActionSheet: Bool = false
    @State private var selectedOption: Int? = nil
    @State private var userInput: String = ""
    @State private var showingCustomAlert = false
    @State private var errorMessage: String?
    @State private var showProgressView: Bool = false
    @State private var showErrorMsgAlert: Bool = false
    @State private var errorMsg: String = ""
    @State private var showCreateUserButton: Bool = true
    @State private var showEmptyView: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NoteListViewModel) {
        self.viewModel = viewModel
        let input = NoteListViewModel.Input.init(
            loadViewTrigger: loadViewTrigger.eraseToAnyPublisher(),
            loadNotesTrigger: loadNotesTrigger.eraseToAnyPublisher(),
            loadUserTrigger: loadUserInfoTrigger.eraseToAnyPublisher(),
            addNoteTrigger: addNoteTrigger.eraseToAnyPublisher(),
            createUserTrigger: createUserTrigger.eraseToAnyPublisher()
        )
        self.output = self.viewModel.transform(input: input)
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Select Options"), buttons: [
            .default(Text("Add Note"), action: {
                self.handleActionSheetOption(option: 1)
            }),
            .default(Text("Show Notes By Current User"), action: {
                self.handleActionSheetOption(option: 2)
            }),
            .default(Text("Show All Notes"), action: {
                self.handleActionSheetOption(option: 3)
            }),
            .cancel()
        ])
    }
    
    var optionsButton: some View {
        Button {
            self.showingActionSheet = true
        } label: {
            Text("Options")
        }.actionSheet(isPresented: $showingActionSheet, content: {
            self.actionSheet
        })
        .alert("Show Add Note", isPresented: $showAlert) {
            TextField("Enter Your Note", text: $userInput)
            Button {
                showAlert = false
            } label: {
                Text("Cancel")
            }
            Button {
                addNoteTrigger.send(userInput)
                showAlert = false
                userInput = ""
            } label: {
                Text("Save")
            }
        }
    }
    
    var createUserButton: some View {
        Group {
            if showCreateUserButton {
                Button("Create User") {
                    showUserAlert = true
                }
                .alert("Create User", isPresented: $showUserAlert) {
                    TextField("Set Your Username", text: $userInput)
                    Button {
                        showUserAlert = false
                    } label: {
                        Text("Cancel")
                    }
                    Button {
                        createUserTrigger.send(userInput)
                        showUserAlert = false
                        userInput = ""
                    } label: {
                        Text("Save")
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
    
    var emptyView: some View {
        Group {
            if showEmptyView {
                Text("No Data")
            } else {
                EmptyView()
            }
        }.background(.gray)
    }
    
    var listNotes: some View {
        List {
            ForEach(notes, id: \.createdAt) { note in
                VStack(alignment: .leading) {
                    Text(note.content)
                        .font(.headline)
                    Text("Created By \(note.userName)")
                        .font(.subheadline)
                    Text("Created At \(note.formatDate)")
                        .font(.subheadline)
                }
            }
        }
        .listStyle(.inset)
        .refreshable {
            loadNotes()
        }
    }
    
    var body: some View {
        NavigationView {
            listNotes
                .navigationBarItems(trailing: optionsButton)
                .navigationBarItems(leading: createUserButton)
                .overlay {
                    ProgressView {
                        Text("Loading...")
                    }.isHidden(!showProgressView)
                    emptyView
                }
                .alert(isPresented: $showErrorMsgAlert, content: {
                    Alert(title: Text("Error"), message: Text(errorMsg),
                          dismissButton: .cancel({
                        showErrorMsgAlert = false
                    }))
                })
        }
        .onReceive(output.state, perform: { state in
            switch state {
            case .ide:
                loadUserInfo()
                loadNotes()
                break
            case .notes(let notes):
                self.notes = notes
                showEmptyView = false
                showProgressView = false
                break
            case .note(_):
                loadNotes()
                break
            case .user(let hide):
                showCreateUserButton = hide
                loadUserInfo()
                break
            case .empty:
                showEmptyView = true
                break
            case .loading:
                self.showProgressView = true
                self.showEmptyView = false
                break
            case .error(let message):
                showErrorMsgAlert = true
                errorMsg = message
                showEmptyView = false
                break
            case .dismiss:
                showProgressView = false
                break
            }
        })
        .onAppear(perform: {
            loadViewTrigger.send(())
        })
    }
    
    private func loadNotes() {
        loadNotesTrigger.send(.all)
    }
    
    private func loadUserInfo() {
        loadUserInfoTrigger.send(())
    }
    
    private func handleActionSheetOption(option: Int) {
        switch option {
        case 1:
            showAlert = true
            break
        case 2:
            loadNotesTrigger.send(.invidual)
            break
        case 3:
            loadNotesTrigger.send(.all)
            break
        default:
            break
        }
        showingActionSheet = false
    }
}
