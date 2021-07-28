//
//  ProfileView.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 100)
                    .padding(.top, 20)
                    .gradientForeground(colors: [.purple, .blue])
                
                Text("Thanks for using")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Text("Soundizer")
                    .font(.title)
                    .fontWeight(.bold)
                    .gradientForeground(colors: [.purple, .blue])
                
                Form {
                    Section {
                        NavigationLink(destination: InfoView()) {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("Info")
                            }
                            .foregroundColor(colorScheme == .light ? Color.init(Color.RGBColorSpace.sRGB, white: 0.0, opacity: 0.65) : Color.gray)
                        }
                    }
                    
                    AccountSection()
                }
                .navigationBarTitle("Settings", displayMode: .inline)
                .navigationBarItems(trailing:
                                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                                            Text("Done")
                                                .gradientForeground(colors: [.purple, .blue])
                                        })
            }
        }
        .accentColor(colorScheme == .light ? Color.init(Color.RGBColorSpace.sRGB, white: 0.0, opacity: 0.65) : Color.gray)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
    }
}

struct AccountSection: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var authenticationVM = AuthenticationService()
    @State private var showSignInView = false
    
    var body: some View {
        Section(footer: footer) {
            button
        }
    }
    
    var footer: some View {
        HStack {
            Spacer()
            if !authenticationVM.isUserLoggedIn {
                Text("You're not logged in.")
            }
            else {
                VStack {
                    Text("Logged in as \((Auth.auth().currentUser?.email)!)")
                }
            }
            Spacer()
        }
        .foregroundColor(colorScheme == .light ? Color.init(Color.RGBColorSpace.sRGB, white: 0.0, opacity: 0.65) : Color.gray)
    }
    
    var button: some View {
        VStack {
            if !authenticationVM.isUserLoggedIn {
                Button(action: { self.login() }) {
                    HStack {
                        Spacer()
                        Text("Login")
                            .gradientForeground(colors: [.purple, .blue])
                        Spacer()
                    }
                }
            }
            else {
                Button(action: { self.logout() }) {
                    HStack {
                        Spacer()
                        Text("Logout")
                            .gradientForeground(colors: [.purple, .blue])
                        Spacer()
                    }
                }
            }
        }
        .sheet(isPresented: self.$showSignInView) {
            SignInView()
        }
    }
    
    func login() {
        self.showSignInView.toggle()
    }
    
    func logout() {
        self.authenticationVM.signOut()
    }
}
