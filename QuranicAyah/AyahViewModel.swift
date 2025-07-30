//
//  AyahViewModel.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 29/07/25.
//

import Foundation
import Combine

class AyahViewModel: ObservableObject {
    @Published var arabicText = ""
    @Published var translation = ""
    @Published var surahName = ""
    @Published var isLoading = false
    @Published var audio = ""
    @Published var isPlaying = false
    @Published var audioPlayer = AudioPlayer()

    private var cancellables = Set<AnyCancellable>()

    init() {
        audioPlayer.onFinish = { [weak self] in
            self?.isPlaying = false
        }
    }

    func fetchRandomAyah() {
        isLoading = true
        let ayahNumber = Int.random(in: 1...6236)
        let arabicURL = URL(string: "https://api.alquran.cloud/v1/ayah/\(ayahNumber)/ar.alafasy")!
        let englishURL = URL(string: "https://api.alquran.cloud/v1/ayah/\(ayahNumber)/en.asad")!

        Publishers.Zip(
            URLSession.shared.dataTaskPublisher(for: arabicURL),
            URLSession.shared.dataTaskPublisher(for: englishURL)
        )
        .tryMap { (arabicData, englishData) in
            let arabicAyah = try JSONDecoder().decode(AyahResponse.self, from: arabicData.data)
            let englishAyah = try JSONDecoder().decode(AyahTranslationResponse.self, from: englishData.data)
            return (arabicAyah.data, englishAyah.data)
        }
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Fetch failed: \(error)")
                }
            },
            receiveValue: { [weak self] (arabic, english) in
                self?.arabicText = arabic.text
                self?.translation = english.text
                self?.surahName = "\(arabic.surah.name) - \(arabic.surah.englishName)"
                self?.audio = arabic.audio ?? ""
                self?.isPlaying = false
                self?.saveToArchive(arabic.text, english.text, arabic.surah.name, arabic.audio ?? "")
            }
        )
        .store(in: &cancellables)
    }

    private func saveToArchive(_ arabic: String, _ english: String, _ surah: String, _ audio: String) {
        let ayah = ["arabic": arabic, "english": english, "surah": surah, "audio": audio]
        var archive = UserDefaults.standard.array(forKey: "ayahArchive") as? [[String: String]] ?? []
        archive.insert(ayah, at: 0)
        UserDefaults.standard.setValue(archive, forKey: "ayahArchive")
    }
}

