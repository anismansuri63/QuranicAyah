//
//  QuranFont.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 30/07/25.
//


enum QuranFont: String, CaseIterable, Identifiable {
    case indopak = "AlQuranIndoPakbyQuranWBW"
    case pdms = "_PDMS_Saleem_QuranFont"
    case majeed = "Al-Majeed-Quranic-Font"
    
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .indopak: return "IndoPak"
        case .pdms: return "PDMS Saleem"
        case .majeed: return "Al Majeed"
        }
    }
}
