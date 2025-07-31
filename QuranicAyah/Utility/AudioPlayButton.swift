//
//  AudioPlayButton.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 31/07/25.
//


import SwiftUI
import AVFoundation

struct AudioPlayButton: View {
    let audioURL: String
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var observer: Any?
    @AppStorage("playbackSpeed") private var playbackSpeed: Double = 1.0
    var body: some View {
        Button(action: {
            if isPlaying {
                player?.pause()
                isPlaying = false
            } else {
                if player == nil {
                    if let url = URL(string: audioURL) {
                        player = AVPlayer(url: url)
                        observer = NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player?.currentItem,
                            queue: .main
                        ) { _ in
                            isPlaying = false
                        }
                    }
                }
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("Failed to set audio session category: \(error)")
                }
                
                player?.play()
                player?.rate = Float(playbackSpeed)
                isPlaying = true
            }
        }) {
            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(.green)
        }
        .onDisappear {
            player?.pause()
            player = nil
            if let obs = observer {
                NotificationCenter.default.removeObserver(obs)
                observer = nil
            }
        }
    }
}
