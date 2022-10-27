//  TextToSpeech.swift
//  Created by Rohit Pandey on 06/10/22.

import AVFoundation


class TextToSpeech {
    let synth = AVSpeechSynthesizer()
    
    func speak(message: String) {
        let myUtterance = AVSpeechUtterance(string: message)
        myUtterance.rate = 0.55
        self.synth.speak(myUtterance)
    }
    
    
}

