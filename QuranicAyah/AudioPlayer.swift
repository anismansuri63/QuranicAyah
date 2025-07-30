//
//  AudioPlayer.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 29/07/25.
//
import SwiftUI
import Foundation
import AVFoundation

class AudioPlayer: ObservableObject {
    private var player: AVPlayer?
    private var observer: Any?

    var onFinish: (() -> Void)?

    func playAudio(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid audio URL")
            return
        }
        stop() // Stop any current audio
        player = AVPlayer(url: url)

        player?.play()
        player?.rate = 1.1

        // Observe end of audio
        observer = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.onFinish?()
        }
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        player?.pause()
        player = nil
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

