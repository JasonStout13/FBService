//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import FirebaseAuth

extension User {
    @discardableResult
    func link(with credential: AuthCredential) async throws -> AuthDataResult {
        return try await withCheckedThrowingContinuation({ continuation in
            self.link(with: credential, completion: { authDataResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                
                guard let authDataResult = authDataResult else {
                    continuation.resume(throwing: NSError(domain: "AuthDataResult is nil", code: 0))
                    return
                }
                
                continuation.resume(returning: authDataResult)
            })
        })
    }
}
