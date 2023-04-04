import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet private weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
    
    private func setupComponents() {
        startButton.setTitle("Start test", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.backgroundColor = .cyan
        startButton.layer.cornerRadius = 4
        startButton.clipsToBounds = true
    }
    
    private func decreaseLevel() {
        
    }
    
    private func increaseLevel() {
        
    }
    
    func createTripLetsNumbers(count: Int) -> [Int] {
        var digits = [Int]()
        for _ in 0..<count {
            let digit = Int.random(in: 0...9)
            digits.append(digit)
        }
        return digits
    }
}
