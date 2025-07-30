//
//  AyahResponse.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 29/07/25.
//


import Foundation

import Foundation

struct AyahResponse: Decodable {
    let code: Int
    let status: String
    let data: AyahData
}
struct AyahTranslationResponse: Decodable {
    let code: Int
    let status: String  
    let data: AyahTranslationData
}

struct AyahTranslationData: Decodable {
    let text: String
    let numberInSurah: Int
    let surah: Surah
    let edition: Edition
}

struct AyahData: Decodable {
    let number: Int
    let audio: String?
    let audioSecondary: [String]?
    let text: String
    let edition: Edition
    let surah: Surah
    let numberInSurah: Int
    let juz: Int
    let manzil: Int
    let page: Int
    let ruku: Int
    let hizbQuarter: Int
    let sajda: Bool
}

struct Edition: Decodable {
    let identifier: String
    let language: String
    let name: String
    let englishName: String
    let format: String
    let type: String
    let direction: String? // Can be null
}

struct Surah: Decodable {
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let numberOfAyahs: Int
    let revelationType: String
}
