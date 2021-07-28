//
//  SignInView.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import SwiftUI

struct SignInView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Logo()
                .frame(width: 100, height: 350)
            
            HStack {
                Text("Welcome to")
                    .font(.title)
                    .gradientForeground(colors: [.purple, .blue])
                
                Text("Soundizer")
                    .font(.title)
                    .fontWeight(.semibold)
                    .gradientForeground(colors: [.purple, .blue])
            }
            
            Text("Create an account to recognize instruments and access from any device.")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .frame(width: 350, height: 100)
                .foregroundColor(colorScheme == .light ? Color.init(Color.RGBColorSpace.sRGB, white: 0.0, opacity: 0.65) : Color.gray)
            
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                         startPoint: .top,
                                         endPoint: .bottom))
                    .frame(width: 320, height: 85)
                SignInWithGoogleButton()
                    .frame(width: 280, height: 45)
            }

            Divider()
                .padding(.horizontal, 15.0)
                .padding(.top, 20.0)
                .padding(.bottom, 15.0)
            
            
            Text("By using Soundizer you agree to our Terms of Use and Service Policy")
                .multilineTextAlignment(.center)
                .frame(width: 350, height: 60)
                .foregroundColor(colorScheme == .light ? Color.init(Color.RGBColorSpace.sRGB, white: 0.0, opacity: 0.65) : Color.gray)
        }
    }
    
}
struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            
    }
}
