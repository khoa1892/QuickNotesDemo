//
//  ContentView.swift
//  QuickNotes
//
//  Created by Khoa Mai on 17/4/24.
//

import SwiftUI
import Combine

struct NotesContentView: View {
    
    var viewModel: NoteListViewModel
    var output: NoteListViewModel.Output
    @State private var notes: [NoteInfo] = []
    @State private var showAlert: Bool = false
    
    private var loadViewTrigger = PassthroughSubject<Void, Never>()
    private var loadNotesTrigger = PassthroughSubject<LoadType, Never>()
    private var addNoteTrigger = PassthroughSubject<String, Never>()
    private var loadUserInfoTrigger = PassthroughSubject<Void, Never>()
    
    @State private var userInput: String = ""
    @State private var showingCustomAlert = false
    @State private var hideLoadingView: Bool = false
    @State private var errorMsg: String = ""
    @State private var showErrorMsgAlert: Bool = false
    @State private var showEmptyView: Bool = false
    @State private var isRotate: Bool = false
    @State private var isPresented: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NoteListViewModel) {
        self.viewModel = viewModel
        let input = NoteListViewModel.Input(
            loadViewTrigger: loadViewTrigger.eraseToAnyPublisher(),
            loadNotesTrigger: loadNotesTrigger.eraseToAnyPublisher(),
            loadUserTrigger: loadUserInfoTrigger.eraseToAnyPublisher(),
            addNoteTrigger: addNoteTrigger.eraseToAnyPublisher()
        )
        self.output = self.viewModel.transform(input: input)
    }
    
    var floatingButton: some View {
        VStack {
            if isRotate {
                Button(action: {
                    withAnimation {
                        isPresented = true
                        isRotate.toggle()
                    }
                }, label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(.blue)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                })
                Button(action: {
                    loadNotes(type: .invidual)
                }, label: {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical, 10).padding(.horizontal, 10)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(.blue)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                })
                Button(action: {
                    loadNotes(type: .all)
                }, label: {
                    Image(systemName: "person.3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical, 5).padding(.horizontal, 5)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(.blue)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                })
            }
            Button {
                withAnimation {
                    isRotate.toggle()
                }
            } label: {
                Image(systemName: isRotate ? "xmark" : "note.text")
                    .font(.title.weight(.semibold))
                    .padding()
                    .background(.red)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(isRotate ? -90 : 0))
                    .clipShape(Circle())
                    .shadow(radius: 4, x: 0, y: 4)
                    .padding(.bottom, isRotate ? 20 : 0)
            }
            .padding()
        }.transition(.scale)
    }
    
    var emptyView: some View {
        Group {
            if showEmptyView {
                EmptyDataView()
            } else {
                EmptyView()
            }
        }
    }
    
    var listNotes: some View {
        List {
            ForEach(notes, id: \.createdAt) { note in
                ListNoteCell(note: note)
            }
        }
        .listStyle(.inset)
        .refreshable {
            loadNotes(type: .all)
        }
    }
    
    var loadingView: some View {
        VStack {
            if hideLoadingView {
                LoadingView()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing, content: {
                listNotes
                emptyView
                floatingButton
                loadingView
            })
            .navigationTitle("Notes").font(.headline)
        }
        .navigationBarBackButtonHidden()
        .alert(isPresented: $showErrorMsgAlert, content: {
            Alert(title: Text("Error"), message: Text(errorMsg),
                  dismissButton: .cancel({
                showErrorMsgAlert = false
            }))
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
        .onReceive(output.state, perform: { state in
            switch state {
            case .ide:
                loadUserInfo()
                break
            case .notes(let notes):
                self.notes = notes
                showEmptyView = false
                hideLoadingView = false
                break
            case .note(_):
                break
            case .empty:
                notes.removeAll()
                hideLoadingView = true
                showEmptyView = true
                break
            case .loading:
                self.hideLoadingView = true
                self.showEmptyView = false
                break
            case .error(let message):
                showErrorMsgAlert = true
                errorMsg = message
                showEmptyView = false
                break
            case .dismiss:
                hideLoadingView = false
                break
            }
        })
        .onAppear(perform: {
            loadViewTrigger.send(())
        })
        .popup(isPresented: $isPresented) {
            BottomPopupView {
                NotePopupView(isPresented: $isPresented) { text in
                    self.addNoteTrigger.send(text)
                }
            }
        }
    }
    
    private func loadNotes(type: LoadType) {
        loadNotesTrigger.send(type)
    }
    
    private func loadUserInfo() {
        loadUserInfoTrigger.send(())
    }
}
