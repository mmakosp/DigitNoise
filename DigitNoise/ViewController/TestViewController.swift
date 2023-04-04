import UIKit
import AVFoundation

class TestViewController: UIViewController {
    
    @IBOutlet private weak var numberInputTextField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var exitTestButton: UIButton!
    
    @IBOutlet private weak var enteredNumberLabel: UILabel!
    var audioPlayer: AVAudioPlayer?
    var digitsInt = [Int]()
    var startTime: Date?
    var timer: Timer?
    let numTrials = 10
    var currentTrial = 0
    var currentDigitIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
    
    
    
    func loadTestElements() {
        playAudioSequence()
    }
    
    private func setupComponents() {
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        
        exitTestButton.setTitle("Exit test", for: .normal)
        exitTestButton.setTitleColor(.black, for: .normal)
    }
    
    var digits: [String] {
        return ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    }
    
    var noise: [String] {
        return ["noise_1", "noise_2", "noise_3", "noise_4", "noise_5", "noise_6", "noise_7", "noise_8", "noise_9"]
    }
    
    var randomDigitsPicked: [String] {
        let shuffledNameArray = digits.shuffled()
        return Array(shuffledNameArray.prefix(1))
    }
    
    // Play the digit and noise sequence
    func playAudioSequence() {
            let audioItems = audioItemsToPlay(arrayToPlay: randomDigitsPicked)
            let player = AVQueuePlayer(items: audioItems)
            player.play()
    }
    
    func audioItemsToPlay(arrayToPlay: [String]) -> [AVPlayerItem] {
            var audioItems: [AVPlayerItem] = []
            for audioName in arrayToPlay {
                let url = Bundle.main.url(forResource: audioName, withExtension: "m4a")
                if let url = url {
                    let item = AVPlayerItem(url: url)
                    audioItems.append(item)
                }
            }
            
            return audioItems
    }
    
    
    
    // Process the user's response for the current trial
    func processResponse(digitCount: String?, noiseCount: String?) {
        // Check if the user's response matches the current digit
        if numberInputTextField.text == digitCount {
            print("Correct!")
        } else {
            print("Incorrect!")
        }
        
        // Advance to the next trial
        currentTrial += 1
        
        if currentTrial < numTrials {
            loadTestElements()
        } else {
            // Test is complete
            print("Test complete!")
        }
    }
    
    func generateRandomDigits(count: Int) -> [Int] {
        var digits = [Int]()
        for _ in 0..<count {
            let digit = Int.random(in: 0...9)
            digits.append(digit)
        }
        return digits
    }
    
    // Handle the next button press
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        // check if digit is correct
        let pressedDigit = sender.tag
        if pressedDigit == digitsInt[currentDigitIndex] {
            // move to next digit
            currentDigitIndex += 1
            if currentDigitIndex < digits.count {
                // display next digit
                enteredNumberLabel.text = "\(digitsInt[currentDigitIndex])"
            } else {
                // test is complete
                timer?.invalidate()
                //timerLabel.isHidden = true
                enteredNumberLabel.text = "Test Complete"
            }
        }
        
        playAudioSequence()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        numberInputTextField.isEnabled = true
        
        numberInputTextField.becomeFirstResponder()
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true)

    }
    
    
    @objc private func tapExitTestButton() {
        dismiss(animated: true)
    }
}
