//
//  AyahDetailView.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 29/07/25.
//

import AVFAudio
import SwiftUI

struct AyahDetailView: View {
    var name: String
    var arabic: String
    var translation: String
    var transliteration: String
    var tafsir: String
    var audio: String
    @AppStorage("selectedFont") private var selectedFont: String = QuranFont.indopak.rawValue

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    Text("Surah: \(name)")
                        .font(.custom(selectedFont, size: 16))
                        .foregroundColor(.black)
                    Spacer()
                    AudioPlayButton(audioURL: audio)
                }

                // Arabic Ayah
                VStack(alignment: .trailing) {
                    Text(arabic)
                        .font(.custom(selectedFont, size: 25))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing) // ⬅️ Add this
                        .padding()
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                VStack {
                    Text(transliteration)
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
                    Text(translation)
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

                    NavigationLink(destination: FullTafsirView(title: name, tafsirText: tafsir)) {
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
    }
}

#Preview {
    AyahView()
}
