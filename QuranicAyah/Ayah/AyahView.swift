//
//  Ayah.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 29/07/25.
//

import SwiftUI

struct AyahView: View {
    @StateObject private var viewModel = AyahViewModel()
    @AppStorage("selectedFont") private var selectedFont: String = QuranFont.indopak.rawValue

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("🕌 Surah: \(viewModel.surahName)")
                        .font(.custom(selectedFont, size: 16))
                        .foregroundColor(.black)
                    // Arabic Ayah
                    GroupBox {
                        Text(viewModel.arabicText)
                            .font(.custom(selectedFont, size: 28))
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)

                    // Audio Controls
                    Button(action: {
                        if viewModel.isPlaying {
                            viewModel.audioPlayer.pause()
                            viewModel.isPlaying = false
                        } else {
                            viewModel.audioPlayer.playAudio(from: viewModel.audio)
                            viewModel.isPlaying = true
                        }
                    }) {
                        Label(viewModel.isPlaying ? "Pause Audio" : "Play Audio", systemImage: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    // Translation & Surah
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📖 Translation")
                            .font(.headline)

                        Text(viewModel.translation)
                            .multilineTextAlignment(.leading)

    
                    }
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(12)

                    // Get New Ayah Button
                    Button(action: viewModel.fetchRandomAyah) {
                        Label("🔄 Get New Ayah", systemImage: "")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(Color.white)
                            .cornerRadius(12)
                    }
                    
                    

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Ayah of the Day")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .foregroundColor(Color.green)
                    }
                    NavigationLink(destination: ArchiveView()) {
                        Image(systemName: "book")
                            .foregroundColor(Color.green)
                    }
                }
            }
            .onAppear {
                viewModel.fetchRandomAyah()
            }
        }
    }
}





#Preview {
    AyahView()
}
