//  ViewController+SpeechToText.swift
//  Created by Rohit Pandey on 06/10/22.

import Foundation

extension ViewController: SpeechSynthesisProtocol {
    
    func synthesizedText(text: String) {
        self.messageLabel.text = text
    }
}
