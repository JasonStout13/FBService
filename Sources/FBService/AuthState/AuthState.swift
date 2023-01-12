//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import Combine
import FirebaseAuth
import FirebaseCore

public class AuthState: ObservableObject {
    @Published public var user: User? = nil
    @Published public var value: AuthenticationStateValue = .undefined
    @Published public var currentUserUid: String? = nil
    @Published public var email: String = ""
    
    public var cancellables: Set<AnyCancellable> = []
    
    public init(shouldLogoutOnLaunch: Bool = false) {
        debugPrint("AuthState init")
        startAuthListener()
        logoutIfNeeded(shouldLogoutOnLaunch)
    }
    
    private func startAuthListener() {
        let promise = AuthListener.listen()
        promise.sink { _ in } receiveValue: { result in
            self.user = result.user
            self.currentUserUid = result.user?.uid
            self.email = result.user?.email ?? ""
            self.value = result.user != nil ? .authenticated : .notAuthenticated
        }.store(in: &cancellables)
    }
    
    private func logoutIfNeeded(_ shouldLogoutOnLaunch: Bool) {
        if shouldLogoutOnLaunch {
            Task {
                do {
                    try Auth.auth().signOut()
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}
