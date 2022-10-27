//  SpeechToTextUseCase.swift
//  Created by Rohit Pandey on 06/10/22.

import Foundation
import Speech

class SpeechToText {
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: Language.instance.setlanguage()))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    let speechSynthesisDelegate: SpeechSynthesisProtocol!
    
    init(receivingClass: SpeechSynthesisProtocol) {
        self.speechSynthesisDelegate = receivingClass
    }
    
    func startRecording() throws {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .measurement, options: .interruptSpokenAudioAndMixWithOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if(result?.bestTranscription.formattedString != nil){
                DispatchQueue.main.async {
                    if let delegate = self.speechSynthesisDelegate {
                        delegate.synthesizedText(text: (result?.bestTranscription.formattedString)!)
                    }
                }
            }
            
            if(result?.isFinal != nil) {
                isFinal = (result?.isFinal)!
            }
            
            if isFinal || error != nil {
                let command = result?.bestTranscription.formattedString
                if command != nil {
                    self.audioEngine.inputNode.removeTap(onBus: 0)
                    self.audioEngine.stop()
                    self.recognitionRequest?.endAudio()
                }
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func endRecording() {
        if audioEngine.isRunning {
            recognitionRequest?.shouldReportPartialResults = false
            audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recognitionTask?.cancel()
            recognitionTask = nil
        }
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
          //Write your code here for handling when speaking
        } else {
            //Write your code here for handling when stopping
        }
    }
}
