//
//  ArchiveView.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 29/07/25.
//


import SwiftUI
import AVFoundation

struct ArchiveView: View {
    @State private var archive: [[String: String]] = []
    @State private var audioPlayer: AVPlayer?
    @State private var currentlyPlayingIndex: Int? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(archive.indices, id: \.self) { index in
                    let ayah = archive[index]

                    VStack(alignment: .leading, spacing: 8) {
                        Text(ayah["arabic"] ?? "")
                            .font(.custom("PDMS Saleem QuranFont", size: 20, relativeTo: .title))
                            .multilineTextAlignment(.leading)

                        Text(ayah["english"] ?? "")
                            .font(.subheadline)
                            .foregroundColor(.primary)

                        HStack {
                            Text("🕌 Surah: \(ayah["surah"] ?? "")")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Spacer()

                            Button(action: {
                                if currentlyPlayingIndex == index {
                                    // Pause if already playing
                                    audioPlayer?.pause()
                                    audioPlayer = nil
                                    currentlyPlayingIndex = nil
                                } else {
                                    if let urlString = ayah["audio"], let url = URL(string: urlString) {
                                        // Stop any current audio
                                        audioPlayer?.pause()

                                        let playerItem = AVPlayerItem(url: url)
                                        audioPlayer = AVPlayer(playerItem: playerItem)
                                        audioPlayer?.play()
                                        audioPlayer?.rate = 1.1
                                        currentlyPlayingIndex = index

                                        // Observe end of playback
                                        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                                               object: playerItem,
                                                                               queue: .main) { _ in
                                            currentlyPlayingIndex = nil
                                            audioPlayer = nil
                                        }
                                    }
                                }
                            }) {
                                Image(systemName: currentlyPlayingIndex == index ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
        .navigationTitle("Saved Ayahs")
        .onAppear {
            archive = UserDefaults.standard.array(forKey: "ayahArchive") as? [[String: String]] ?? []
        }
    }
}



