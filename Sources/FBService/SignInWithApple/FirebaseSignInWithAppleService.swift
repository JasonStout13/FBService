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

public class FirebaseSignInWithAppleService: NSObject, ObservableObject {
    
    private var onCompleted: ((FirebaseSignInWithAppleResult) -> ())? = nil
    private var onFailed: ((Error) -> ())? = nil
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    public func signIn(onCompleted: @escaping (FirebaseSignInWithAppleResult) -> (), onFailed: @escaping (Error) -> ()) {
        self.onCompleted = onCompleted
        self.onFailed = onFailed
        
        let nonce = FirebaseSignInWithAppleUtils.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = FirebaseSignInWithAppleUtils.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension FirebaseSignInWithAppleService: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        FirebaseSignInWithAppleUtils.createToken(from: authorization, currentNonce: currentNonce) { result in
            switch result {
            case .success(let firebaseSignInWithAppleResult):
                self.onCompleted?(firebaseSignInWithAppleResult)
            case .failure(let err):
                self.onFailed?(err)
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onFailed?(error)
    }
}

#if os(iOS)
extension FirebaseSignInWithAppleService: ASAuthorizationControllerPresentationContextProviding {
    
    public var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
    }
    
}
#endif

#if os(macOS)
extension FirebaseSignInWithAppleService: ASAuthorizationControllerPresentationContextProviding {
    
    public var window: NSWindow? {
        guard let window = NSApplication.shared.keyWindow else {
            return nil
        }
        return window
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
    }
    
}
#endif
