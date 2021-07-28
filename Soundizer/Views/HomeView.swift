//
//  ContentView.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 16/12/2020.
//

import SwiftUI
import SoundAnalysis
import CoreML

let numberOfSamples: Int = 10
let logoLevels: [CGFloat] = [50,100,150,200,250,250,200,150,100,50]

enum ActiveSheet {
    case first, second
}

struct HomeView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var isListening = false
    @State var showSheet = false
    @State private var activeSheet: ActiveSheet = .first
    @State var result = ""
    
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    @ObservedObject private var analizer = InstrumentAnalizer()
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2
        
        return CGFloat(level * (300 / 25))
    }
    
    var showListButton: some View {
        NavigationLink(destination: InstrumentListView()) {
            Image(systemName: "guitars.fill")
                .imageScale(.large)
                .padding()
        }
        .foregroundColor(.purple)
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    if isListening {
                        Text("Listening...")
                            .foregroundColor(.gray)
                            .font(.title2)
                    } else {
                        Text("Tap to use Soundize")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                    
                    HStack(spacing: 4) {
                        if isListening {
                            ForEach(mic.soundSamples, id: \.self) { level in
                                BarView(value: self.normalizeSoundLevel(level: level))
                            }
                        } else {
                            ForEach(logoLevels, id: \.self) { level in
                                BarView(value: level)
                            }
                            .onTapGesture {
                                self.isListening.toggle()
                                mic.startMonitoring()
                                analizer.startAudioAnalysis()
                            }
                        }
                    }
                    .frame(width: 100, height: 350)
                    .navigationBarItems(leading: Button(action: {
                        self.showSheet.toggle()
                        self.activeSheet = .first
                    }) {
                        Image(systemName: "person.circle")
                            .imageScale(.large)
                            .padding()
                            .foregroundColor(.purple)
                    }, trailing: showListButton)
                    
                    .sheet(isPresented: $showSheet) {
                        if self.activeSheet == .first {
                            ProfileView()
                        }
                        else {
                            ResultHostView(showingResult: $showSheet, name: result)
                        }
                    }
                    
                    Text(analizer.result ?? "")
                        .font(.custom("resultFont", size: 20))
                        .frame(width: 200, height: 30, alignment: .center)
                        .foregroundColor(.gray)
                    
                    Text(analizer.confidence ?? "")
                        .font(.custom("resultFont", size: 15))
                        .frame(width: 200, height: 30, alignment: .center)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    if isListening {
                        HStack {
                            Button(action: {
                                withAnimation() {
                                    self.isListening.toggle()
                                    analizer.stopAudioAnalysis()
                                    mic.stopMonitoring()
                                    analizer.result = ""
                                    analizer.confidence = ""
                                }
                            }) {
                                Text("Cancel")
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .gradientForeground(colors: [.purple, .blue])
                                    .frame(width: 100, height: 50)
                            }
                            
                            Button(action: {
                                withAnimation() {
                                    self.isListening.toggle()
                                    analizer.stopAudioAnalysis()
                                    mic.stopMonitoring()
                                    result = analizer.result
                                    analizer.result = ""
                                    analizer.confidence = ""
                                    showSheet.toggle()
                                    self.activeSheet = .second
                                }
                            }) {
                                Text("Save")
                                    .fontWeight(.bold)
                                    .font(.title3)
                                    .gradientForeground(colors: [.purple, .blue])
                                    .frame(width: 100, height: 50)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .accentColor(colorScheme == .light ? Color.init(Color.RGBColorSpace.sRGB, white: 0.0, opacity: 0.65) : Color.gray)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
