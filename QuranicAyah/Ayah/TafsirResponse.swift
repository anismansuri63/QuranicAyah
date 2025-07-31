//
//  TafsirResponse.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 31/07/25.
//


import Foundation
// MARK: - Root Object
struct TafsirResponse: Codable {
    let tafsir: TafsirData?
}

// MARK: - Tafsir Data
struct TafsirData: Codable {
    let verses: [String: TafsirVerse]?
    let resourceID: Int?
    let resourceName: String?
    let languageID: Int?
    let slug: String?
    let translatedName: TranslatedName?
    let text: String?

    enum CodingKeys: String, CodingKey {
        case verses
        case resourceID = "resource_id"
        case resourceName = "resource_name"
        case languageID = "language_id"
        case slug
        case translatedName = "translated_name"
        case text
    }
    func transliteration(verse: String) -> String {
        return (verses?[verse]?.words?.map { $0.transliteration!.text ?? "" }.joined(separator: " ")) ?? ""
    }
}

// MARK: - Translated Name
struct TranslatedName: Codable {
    let name: String?
    let languageName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case languageName = "language_name"
    }
}

// MARK: - Tafsir Verse
struct TafsirVerse: Codable {
    let id: Int?
    let words: [TafsirWord]?
}

// MARK: - Tafsir Word
struct TafsirWord: Codable {
    let id: Int?
    let position: Int?
    let audioURL: String?
    let codeV1: String?
    let pageNumber: Int?
    let charTypeName: String?
    let lineNumber: Int?
    let text: String?
    let translation: TafsirLangText?
    let transliteration: TafsirLangText?

    enum CodingKeys: String, CodingKey {
        case id
        case position
        case audioURL = "audio_url"
        case codeV1 = "code_v1"
        case pageNumber = "page_number"
        case charTypeName = "char_type_name"
        case lineNumber = "line_number"
        case text
        case translation
        case transliteration
    }
}

// MARK: - Translation & Transliteration
struct TafsirLangText: Codable {
    let text: String?
    let languageName: String?
    let languageID: Int?

    enum CodingKeys: String, CodingKey {
        case text
        case languageName = "language_name"
        case languageID = "language_id"
    }
}

