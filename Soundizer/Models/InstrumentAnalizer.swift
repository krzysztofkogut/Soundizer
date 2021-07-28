//
//  InstrumentAnalizer.swift
//  Soundizer
//
//  Created by Krzysztof Kogut on 17/12/2020.
//

import Foundation
import CoreML
import SoundAnalysis
import AVFoundation

class InstrumentAnalizer: ObservableObject {
    
    @Published var result: String!
    @Published var confidence: String!
    @Published var isSet: Bool = false
    
    var streamAnalyzer: SNAudioStreamAnalyzer!
    
    var audioEngine: AVAudioEngine!
    var inputBus: AVAudioNodeBus!
    var inputFormat: AVAudioFormat!
    
    var resultsObserver: ResultsObserver!
    
    var lastResult: String!
    var newResult: String!
    
    // Serial dispatch queue used to analyze incoming audio buffers.
    let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    
    lazy var soundClassifier = try! InstrumentClassifier()
    lazy var model = soundClassifier.model

    func startAudioEngine() {
        
        do {
            // Start the stream of audio data.
            try audioEngine.start()
        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }
    
    func startAudioAnalysis() {
                
        // Create a new audio engine.
        audioEngine = AVAudioEngine()

        // Get the native audio format of the engine's input bus.
        inputBus = AVAudioNodeBus(0)
        inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)
        
        // Create a new stream analyzer.
        streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)

        // Create a new observer that will be notified of analysis results.
        resultsObserver = ResultsObserver()
        
        do {
            // Prepare a new request for the trained model.
            let request = try SNClassifySoundRequest(mlModel: model)
            try streamAnalyzer.add(request, withObserver: resultsObserver)
        } catch {
            print("Unable to prepare request: \(error.localizedDescription)")
            return
        }
        
        // Install an audio tap on the audio engine's input node.
        audioEngine.inputNode.installTap(onBus: inputBus,
                                         bufferSize: 8192, // 8k buffer
                                         format: inputFormat) { buffer, time in
            
            // Analyze the current audio buffer.
            self.analysisQueue.async {
                self.streamAnalyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
                DispatchQueue.main.async {
                    self.result = self.resultsObserver.classificationResult
                    self.confidence = "Confidence: \(Int(self.resultsObserver.classificationConfidence))%"
                }
            }
        }
        
        startAudioEngine()  
    }
    
    func stopAudioAnalysis() {
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
