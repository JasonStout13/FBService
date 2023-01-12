//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import Combine
import Firebase

public struct AuthListener {
    public static func listen() -> PassthroughSubject<AuthListenerResult, Error> {
        let subject = PassthroughSubject<AuthListenerResult, Error>()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            let result = AuthListenerResult(auth: auth, user: user)
            subject.send(result)
        }
        
        return subject
    }
}

public struct AuthListenerResult {
    public let auth: Auth
    public let user: User?
}
