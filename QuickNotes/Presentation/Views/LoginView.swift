//
//  LoginView.swift
//  QuickNotes
//
//  Created by Khoa Mai on 25/4/24.
//

import Foundation
import SwiftUI
import Combine

struct LoginView: View {
    
    @State private var username = ""
    @State private var isNoteActive = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var userId: String?
    @State private var hideLoadingView: Bool = false
    
    private var loginUserTrigger = PassthroughSubject<String, Never>()
    
    private var viewModel: LoginViewModel
    private var output: LoginViewModel.Output
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        let input = LoginViewModel.Input.init(loginUserTrigger: loginUserTrigger.eraseToAnyPublisher())
        self.output = viewModel.transform(input: input)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter your username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: login) {
                    Text("Set Username")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .onReceive(output.state, perform: { state in
                    switch state {
                    case .message(let message):
                        showAlert = true
                        alertMessage = message
                        hideLoadingView = true
                        break
                    case .success(let userId):
                        self.userId = userId
                        isNoteActive = true
                        hideLoadingView = true
                        break
                    case .loading:
                        hideLoadingView = false
                        break
                    }
                })
                .navigationDestination(isPresented: $isNoteActive) {
                    NotesContentView(viewModel: NoteListViewModel.init(userId: userId))
                }
                .overlay {
                    LoadingView().isHidden(!hideLoadingView)
                }
            }
            .padding()
        }
        
    }
    
    func login() {
        self.loginUserTrigger.send(username)
    }
    
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
