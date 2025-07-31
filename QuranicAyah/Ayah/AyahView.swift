//
//  Ayah.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 29/07/25.
//

import AVFAudio
import SwiftUI

struct AyahView: View {
    @StateObject private var viewModel = AyahViewModel()
    @AppStorage("selectedFont") private var selectedFont: String = QuranFont.indopak.rawValue
    @State private var hasLoaded = false // 👈 Track if loaded

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Button(action: {
                        Task {
                            await viewModel.fetchRandomAyah()
                            await viewModel.fetchTafsir()
                        }

                    }) {
                        Label("🔄 Get New Ayah", systemImage: "")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(Color.white)
                            .cornerRadius(12)
                    }
                    HStack {
                        Text("Surah: \(viewModel.surahName)")
                            .font(.custom(selectedFont, size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        AudioPlayButton(audioURL: viewModel.audio)
                    }

                    // Arabic Ayah
                    VStack(alignment: .trailing) {
                        Text(viewModel.arabicText)
                            .font(.custom(selectedFont, size: 25))
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing) // ⬅️ Add this
                            .padding()
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    VStack {
                        Text(viewModel.transliteration)
                            .font(.title3)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading) // ⬅️ Add this

                            .padding()
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)

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
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📖 Tafsir")
                            .font(.headline)
                        // Text(viewModel.tafsir.removingHTMLTags)
                        //  .lineLimit(3)
                        //  .multilineTextAlignment(.leading)

                        NavigationLink(destination: FullTafsirView(title: viewModel.surahName, tafsirText: viewModel.tafsir)) {
                            Text("Click for Full Tafsir")
                                .font(.subheadline)
                                .foregroundColor(.green)
                                .padding(.top, 4)
                        }
                    }

                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(12)

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
                if !hasLoaded {
                    hasLoaded = true
                    Task {
                        await viewModel.fetchRandomAyah()
                        await viewModel.fetchTafsir()
                    }
                }
            }
        }
    }
}

#Preview {
    AyahView()
}
