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
    @AppStorage("playbackSpeed") private var playbackSpeed: Double = 1.0

    func playAudio(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid audio URL")
            return
        }
        stop() // Stop any current audio
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
        player = AVPlayer(url: url)

        player?.play()
        player?.rate = Float(playbackSpeed)

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

