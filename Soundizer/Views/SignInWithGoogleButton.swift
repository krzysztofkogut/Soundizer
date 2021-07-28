//
//  SignInWithGoogle.swift
//  Make It So
//
//  Created by Krzysztof Kogut on 10/12/2020.
//

import SwiftUI
import GoogleSignIn

struct SignInWithGoogleButton: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<SignInWithGoogleButton>) -> GIDSignInButton{
        let button = GIDSignInButton()
        button.colorScheme = .light
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<SignInWithGoogleButton>) {
    }
}
