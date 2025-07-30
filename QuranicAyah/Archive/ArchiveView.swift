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
    @AppStorage("selectedFont") private var selectedFont: String = QuranFont.indopak.rawValue
    @AppStorage("playbackSpeed") private var playbackSpeed: Double = 1.0
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if archive.isEmpty {
                    Text("🗃️ No saved ayahs.")
                        .foregroundColor(.secondary)
                        .padding(.top, 50)
                } else {
                    ForEach(archive.indices, id: \.self) { index in
                        let ayah = archive[index]

                        VStack(alignment: .leading, spacing: 8) {
                            Text(ayah["arabic"] ?? "")
                                .font(.custom(selectedFont, size: 28))
                                .multilineTextAlignment(.leading)

                            Text(ayah["english"] ?? "")
                                .font(.subheadline)
                                .foregroundColor(.primary)

                            HStack {
                                Text("🕌 Surah: \(ayah["surah"] ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.black)

                                Spacer()

                                Button(action: {
                                    if currentlyPlayingIndex == index {
                                        audioPlayer?.pause()
                                        audioPlayer = nil
                                        currentlyPlayingIndex = nil
                                    } else {
                                        if let urlString = ayah["audio"], let url = URL(string: urlString) {
                                            audioPlayer?.pause()

                                            do {
                                                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                                                try AVAudioSession.sharedInstance().setActive(true)
                                            } catch {
                                                print("Failed to set audio session category: \(error)")
                                            }


                                            let playerItem = AVPlayerItem(url: url)
                                            audioPlayer = AVPlayer(playerItem: playerItem)
                                            audioPlayer?.play()
                                            audioPlayer?.rate = Float(playbackSpeed)
                                            currentlyPlayingIndex = index

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
                                        .foregroundColor(.green)
                                }

                                // 🗑 Delete Single Ayah
                                Button(action: {
                                    deleteAyah(at: index)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }

                    // 🧹 Delete All Button
                    Button(role: .destructive) {
                        deleteAllAyahs()
                    } label: {
                        Label("Delete All", systemImage: "trash.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 16)
                }
            }
            .padding()
        }
        .navigationTitle("Saved Ayahs")
        .onAppear {
            archive = UserDefaults.standard.array(forKey: "ayahArchive") as? [[String: String]] ?? []
        }
    }

    private func deleteAyah(at index: Int) {
        archive.remove(at: index)
        UserDefaults.standard.set(archive, forKey: "ayahArchive")
    }

    private func deleteAllAyahs() {
        archive.removeAll()
        UserDefaults.standard.removeObject(forKey: "ayahArchive")
    }
}




