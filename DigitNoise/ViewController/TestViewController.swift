import UIKit
import AVFoundation

enum Noise: String {
    case noise_1
    case noise_2
    case noise_3
    case noise_4
    case noise_5
    case noise_6
    case noise_7
    case noise_8
    case noise_9
    case noise_10
}

class TestViewController: UIViewController {
    
    @IBOutlet private weak var numberInputTextField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var exitTestButton: UIButton!
    
    @IBOutlet private weak var enteredNumberLabel: UILabel!
    var audioPlayer: AVAudioPlayer?
    var startTime: Date?
    var timer: Timer?
    
    var currentTrial = 0
    var currentTestLevel: Int = 5
    var pickedNumbers: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        loadFirstTest()
        playAddObserver()
    }
    
    func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let startTime = self?.startTime else { return }
            let elapsedTime = Date().timeIntervalSince(startTime)
            self?.enteredNumberLabel.text = String(format: "%.1f", elapsedTime)
        }
    }
    
    private func loadFirstTest() {
        initialNoisePlay.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let playerQueue = self.playerQueue {
                playerQueue.play()
            }
        }
    }
    
    private var setupNoiseLevel: Noise {
        switch currentTestLevel {
        case 1:
            return .noise_1
        case 2:
            return .noise_2
        case 3:
            return .noise_3
        case 4:
            return .noise_4
        case 5:
            return .noise_5
        case 6:
            return .noise_6
        case 7:
            return .noise_7
        case 8:
            return .noise_8
        case 9:
            return .noise_9
        default:
            return .noise_10
        }
    }
    
    private func setupComponents() {
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.isEnabled = false
        numberInputTextField.isEnabled = false
        numberInputTextField.font = UIFont(name: "Avenir", size: 100)
        enteredNumberLabel.text = "Enter the number"
        
        exitTestButton.setTitle("Exit test", for: .normal)
        exitTestButton.setTitleColor(.black, for: .normal)
    }
    
    var digits: [String] {
        return ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    }
    
    var noise: [String] {
        return ["noise_1", "noise_2", "noise_3", "noise_4", "noise_5", "noise_6", "noise_7", "noise_8", "noise_9", "noise_10"]
    }
    
    var randomDigitsPicked: [String] {
        return digits[randomPick: 3]
    }
    
    lazy var playerQueue: AVQueuePlayer? = {
        guard let url1 = Bundle.main.url(forResource: randomDigitsPicked[0], withExtension: "m4a"),
              let url2 = Bundle.main.url(forResource: randomDigitsPicked[1], withExtension: "m4a"),
              let url3 = Bundle.main.url(forResource: randomDigitsPicked[2], withExtension: "m4a") else { return nil }
        let item1 = AVPlayerItem(url: url1)
        let item2 = AVPlayerItem(url: url2)
        let item3 = AVPlayerItem(url: url3)
        
        pickedNumbers = randomDigitsPicked[0] + randomDigitsPicked[0] + randomDigitsPicked[0]
        
        let queue = AVQueuePlayer(items: [item1, item2, item3])
        return queue
    }()
    
    lazy var initialNoisePlay: AVQueuePlayer = {
        let audioEngine = AVAudioEngine()
        let url1 = Bundle.main.url(forResource: setupNoiseLevel.rawValue, withExtension: "m4a")!
        let item1 = AVPlayerItem(url: url1)
        let queue = AVQueuePlayer(items: [item1])
        return queue
    }()
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        //verifyNumbers()
        DispatchQueue.main.async {
            self.verifyNumbers()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let playerQueue = self.playerQueue {
                playerQueue.play()
            }
        }
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func verifyNumbers() {
        if let numberEntered = numberInputTextField.text {
            if numberEntered == pickedNumbers {
                print("Correct!")
                if currentTestLevel >= 10  {
                    enteredNumberLabel.text = "You completed the test"
                } else {
                    currentTestLevel += 1
                }
                
            } else {
                if currentTestLevel > 1 {
                    currentTestLevel -= 1
                }
                print("Incorrect!")
            }
        }
        numberInputTextField.text = ""
    }
    
    private func playAddObserver() {
        if let playerQueue = playerQueue?.currentItem {
            NotificationCenter.default
                .addObserver(self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                             object: playerQueue
            )
        }
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Play Finished")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let playerQueue = self.playerQueue {
                self.initialNoisePlay.pause()
                self.numberInputTextField.isEnabled = true
                self.numberInputTextField.becomeFirstResponder()
                self.submitButton.isEnabled = true
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension Array {
    subscript (randomPick n: Int) -> [Element] {
        var copy = self
        for i in stride(from: count - 1, to: count - n - 1, by: -1) {
            copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
        return Array(copy.suffix(n))
    }
}
