//  ViewController.swift
//  Created by Rohit Pandey on 28/09/22.
//

import UIKit
import Speech

class ViewController: UIViewController {
    @IBOutlet var messageLabel: UIPaddedLabel!
    @IBOutlet var speakButton: UIButton!
    var speechToTextUseCase: SpeechToText!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechToTextUseCase = SpeechToText(receivingClass: self)
        customizeViewsElements()
    }
    
    func customizeViewsElements() {
        messageLabel.layer.borderWidth = 0.5
        messageLabel.layer.borderColor = UIColor.black.cgColor
        messageLabel.layer.cornerRadius = 4.0
        messageLabel.numberOfLines = 0
        
        speakButton.layer.cornerRadius = 4.0
        speakButton.layer.borderWidth = 1.0
        speakButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func speak(_ sender: Any) {
        speakButton.isSelected = !speakButton.isSelected
        if (speakButton.isSelected) {
            speakButton.setImage(UIImage.init(named: "microphone-disabled"), for: .selected)
            messageLabel.text = "Speak Now..I am listening"
            messageLabel.textAlignment = .center
            try! speechToTextUseCase.startRecording()
        }
        else {
            speechToTextUseCase.endRecording()
            speakButton.setImage(UIImage.init(named: "microphone-enabled"), for: .normal)
        }
    }
    
    @IBAction func clickToListen(_ sender: Any) {
        let textToSpeech = TextToSpeech()
        textToSpeech.speak(message: "Hey..Thanks for clicking me...you can change the text in code and I'll speak for you")
    }
}


