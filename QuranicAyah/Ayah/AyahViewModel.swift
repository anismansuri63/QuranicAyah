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
    @Published var tafsir = ""
    @Published var transliteration = ""

    private var cancellables = Set<AnyCancellable>()
    private var currentSurah: Int?
    private var currentAyah: Int?

    init() {
        
    }

    @MainActor
    func fetchRandomAyah() async {
        isLoading = true
        tafsir = "" // Reset tafsir while loading new ayah

        let ayahNumber = Int.random(in: 1...6236)
        let arabicURL = URL(string: "https://api.alquran.cloud/v1/ayah/\(ayahNumber)/ar.alafasy")!
        let englishURL = URL(string: "https://api.alquran.cloud/v1/ayah/\(ayahNumber)/en.asad")!

        do {
            async let arabicData = URLSession.shared.data(from: arabicURL)
            async let englishData = URLSession.shared.data(from: englishURL)

            let (arabicRaw, _) = try await arabicData
            let (englishRaw, _) = try await englishData

            let arabicAyah = try JSONDecoder().decode(AyahResponse.self, from: arabicRaw)
            let englishAyah = try JSONDecoder().decode(AyahTranslationResponse.self, from: englishRaw)

            let arabic = arabicAyah.data
            let english = englishAyah.data

            self.arabicText = arabic.text
            self.translation = english.text
            self.audio = arabic.audio ?? ""

            if let surahAyah = getSurahAndAyah(for: ayahNumber) {
                currentSurah = surahAyah.surah
                currentAyah = surahAyah.ayah
                self.surahName = "\(arabic.surah.name) - \(arabic.surah.englishName) | \(surahAyah.surah):\(surahAyah.ayah)"
            } else {
                self.surahName = "\(arabic.surah.name) - \(arabic.surah.englishName)"
            }

        } catch {
            print("Fetch failed: \(error)")
        }

        isLoading = false
    }

    @MainActor
    func fetchTafsir() async {
        guard let surah = currentSurah, let ayah = currentAyah else { return }
        do {
            if let tafsirData = try await fetchTafsirFor(surah: surah, ayah: ayah) {
                self.tafsir = tafsirData.text ?? ""
                self.transliteration = tafsirData.transliteration(verse: "\(surah):\(ayah)")
                saveToArchive(name: self.surahName, arabic: self.arabicText, translation: self.translation, transliteration: self.transliteration, tafsir: self.tafsir, audio: self.audio)
            }
        } catch {
            print("Tafsir fetch failed: \(error)")
        }
    }
    
    private func saveToArchive(name: String, arabic: String, translation: String, transliteration: String, tafsir: String, audio: String) {
        let ayah: [String: String] = [
            "arabic": arabic,
            "english": translation,
            "surah": name,
            "audio": audio,
            "transliteration": transliteration,
            "tafsir": tafsir
        ]

        var archive = UserDefaults.standard.array(forKey: "ayahArchive") as? [[String: String]] ?? []
        archive.insert(ayah, at: 0)
        UserDefaults.standard.setValue(archive, forKey: "ayahArchive")
    }

    func getSurahAndAyah(for globalAyahNumber: Int) -> (surah: Int, ayah: Int)? {
        let ayahsPerSurah = [
            7, 286, 200, 176, 120, 165, 206, 75, 129, 109,
            123, 111, 43, 52, 99, 128, 111, 110, 98, 135,
            112, 78, 118, 64, 77, 227, 93, 88, 69, 60,
            34, 30, 73, 54, 45, 83, 182, 88, 75, 85,
            54, 53, 89, 59, 37, 35, 38, 29, 18, 45,
            60, 49, 62, 55, 78, 96, 29, 22, 24, 13,
            14, 11, 11, 18, 12, 12, 30, 52, 52, 44,
            28, 28, 20, 56, 40, 31, 50, 40, 46, 42,
            29, 19, 36, 25, 22, 17, 19, 26, 30, 20,
            15, 21, 11, 8, 8, 19, 5, 8, 8, 11,
            11, 8, 3, 9, 5, 4, 7, 3, 6, 3,
            5, 4, 5, 6
        ]

        guard globalAyahNumber >= 1 && globalAyahNumber <= 6236 else {
            return nil
        }

        var currentAyahCount = 0
        for (index, ayahCount) in ayahsPerSurah.enumerated() {
            let nextAyahCount = currentAyahCount + ayahCount
            if globalAyahNumber <= nextAyahCount {
                let surahNumber = index + 1
                let ayahNumber = globalAyahNumber - currentAyahCount
                return (surah: surahNumber, ayah: ayahNumber)
            }
            currentAyahCount = nextAyahCount
        }
        return nil
    }

    func fetchTafsirFor(surah: Int, ayah: Int, tafsirResourceId: Int = 169, locale: String = "en", includeWords: Bool = true) async throws -> TafsirData? {
        let verseKey = "\(surah):\(ayah)"
        let urlComponents = URLComponents(string: "https://api.qurancdn.com/api/v4/tafsirs/\(tafsirResourceId)/by_ayah/\(verseKey)?locale=\(locale)&words=\(includeWords)")!
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(TafsirResponse.self, from: data)
        return decoded.tafsir
    }
}


