//
//  QuickNotesApp.swift
//  QuickNotes
//
//  Created by Khoa Mai on 17/4/24.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct QuickNotesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NotesContentView(
                viewModel: NoteListViewModel(
                    noteInfoUseCase: NoteInfoUseCase(
                        repository: NoteInfoRepository()
                    ),
                    userInfoUseCase: UserInfoUseCase(
                        repository: UserInfoRepository()
                    )
                )
            )
        }
    }
}
