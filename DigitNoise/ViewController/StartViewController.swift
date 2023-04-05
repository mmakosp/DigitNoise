import UIKit
import AVFoundation

class StartViewController: UIViewController {
    
    @IBOutlet private weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        resetTestLevel()
    }
    
    private func setupComponents() {
        startButton.setTitle("Start test", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.backgroundColor = .cyan
        startButton.layer.cornerRadius = 4
        startButton.clipsToBounds = true
    }
    
    func resetTestLevel() {
        let testNoiseUserLevel = 5
        UserDefaults.standard.set(testNoiseUserLevel, forKey: "TestNoiseUserLevel")

    }
}
