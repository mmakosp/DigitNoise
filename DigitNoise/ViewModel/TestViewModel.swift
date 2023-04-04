import Foundation
import AVFoundation

class TestViewModel {
    var digits: [String] {
        return ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    }
    
    var noise: [String] {
        return ["noise_1", "noise_2", "noise_3", "noise_4", "noise_5", "noise_6", "noise_7", "noise_8", "noise_9"]
    }
    
    var randomDigitsPicked: [String] {
        let shuffledNameArray = digits.shuffled()
        return Array(shuffledNameArray.prefix(3))
    }
    
    var randomNoisesPicked: [String] {
        let shuffledNameArray = noise.shuffled()
        return Array(shuffledNameArray.prefix(3))
    }
}

class Player: NSObject, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer?

    func audioItemsToPlay(url: URL, arrayToPlay: [String]) -> [AVPlayerItem] {
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
}

