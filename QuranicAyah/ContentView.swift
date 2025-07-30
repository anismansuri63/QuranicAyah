//
//  ContentView.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 29/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AyahViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Fetching Ayah...")
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text(viewModel.arabicText)
                            .font(.custom("PDMS Saleem QuranFont", size: 28, relativeTo: .title))
                            .multilineTextAlignment(.center)
                            .padding()
                        
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
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("📖 Translation:")
                                .font(.headline)

                            Text(viewModel.translation)
                                .multilineTextAlignment(.leading)

                            Text("🕌 Surah: \(viewModel.surahName)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }

                    Button(action: viewModel.fetchRandomAyah) {
                        Label("🔄 Get New Ayah", systemImage: "arrow.clockwise.circle")
                    }
                    .buttonStyle(.borderedProminent)

                    NavigationLink("📜 View Archive", destination: ArchiveView())
                        .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("Ayah of the Day")
        }
        .onAppear {
            viewModel.fetchRandomAyah()
        }
    }
}



#Preview {
    ContentView()
}
