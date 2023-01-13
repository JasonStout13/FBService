//  Project:  
// Created by Jason Stout on 1/11/23.
//
// Using Swift 5.0
// Running on macOS 13.0
// File
//
// "Design is not just what it looks like and feels like. Design is how it works." - Steve Jobs

import AuthenticationServices
import FirebaseAuth
import SwiftUI

public struct FirebaseSignInWithAppleButton: View {
    
    private var label: SignInWithAppleButton.Label
    private var requestedScopes: [ASAuthorization.Scope]?
    private var onCompletion: ((Result<FirebaseSignInWithAppleResult, Error>) -> Void)
    
    @State private var currentNonce: String? = nil
    
    public init(label: SignInWithAppleButton.Label = .signIn, requestedScopes: [ASAuthorization.Scope]? = [.fullName, .email], onCompletion: @escaping ((Result<FirebaseSignInWithAppleResult, Error>) -> Void) = {_ in}) {
        self.label = label
        self.requestedScopes = requestedScopes
        self.onCompletion = onCompletion
    }
    
    public var body: some View {
        SignInWithAppleButton(label) { (request) in
            request.requestedScopes = requestedScopes
            let nonce = FirebaseSignInWithAppleUtils.randomNonceString()
            currentNonce = nonce
            request.nonce = FirebaseSignInWithAppleUtils.sha256(nonce)
        } onCompletion: { (result) in
            switch result {
            case .success(let authorization):
                FirebaseSignInWithAppleUtils.createToken(from: authorization, currentNonce: currentNonce) { result in
                    switch result {
                    case .success(let firebaseSignInWithAppleResult):
                        onCompletion(.success(firebaseSignInWithAppleResult))
                    case .failure(let err):
                        onCompletion(.failure(err))
                    }
                }
            case .failure(let err):
                onCompletion(.failure(err))
            }
        }
    }
    
}
