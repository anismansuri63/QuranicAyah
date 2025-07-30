//
//  SettingsView.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 30/07/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedFont") private var selectedFont: String = QuranFont.indopak.rawValue
    @AppStorage("playbackSpeed") private var playbackSpeed: Double = 1

    var body: some View {
        Form {
            Section(header: Text("Font Selection")) {
                Picker("Choose Font", selection: $selectedFont) {
                    ForEach(QuranFont.allCases) { font in
                        Text(font.displayName)
                            .font(.custom(font.rawValue, size: 18))
                            .tag(font.rawValue)
                    }
                }
            }

            Section(header: Text("Playback Speed")) {
                VStack(alignment: .leading) {
                    Slider(value: $playbackSpeed, in: 1.0...2.0, step: 0.1)
                    Text("Speed: \(String(format: "%.1f", playbackSpeed))x")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Settings")
    }
}

