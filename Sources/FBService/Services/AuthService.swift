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

public struct AuthService {
    public static func currentUserUid() -> String? {
        Auth.auth().currentUser?.uid
    }
    
    @discardableResult
    public static func signIn(withEmail email: String, password: String) async throws -> AuthDataResult {
        if Auth.auth().currentUser == nil {
            return try await Auth.auth().signIn(withEmail: email, password: password)
        } else {
            throw FirebaseError.alreadySignedIn
        }
    }
    
    @discardableResult
    public static func signUp(withEmail email: String, password: String) async throws -> AuthDataResult {
        if Auth.auth().currentUser == nil {
            return try await Auth.auth().createUser(withEmail: email, password: password)
        } else {
            throw FirebaseError.alreadySignedIn
        }
    }
    
    @discardableResult
    public static func login(withEmail email: String, password: String) async throws -> AuthDataResult {
        if Auth.auth().currentUser == nil {
            do {
                return try await Auth.auth().signIn(withEmail: email, password: password)
            } catch {
                if error._code == 17011 {
                    return try await Auth.auth().createUser(withEmail: email, password: password)
                } else {
                    throw error
                }
            }
        } else {
            throw FirebaseError.alreadySignedIn
        }
    }
    
    @discardableResult
    public static func logout() async throws -> Bool {
        try await withCheckedThrowingContinuation({ continuation in
            logout { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
    private static func logout(completion: @escaping (Result<Bool, Error>) -> ()) {
        DispatchQueue.global(qos: .background).async {
            do {
                try Auth.auth().signOut()
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
