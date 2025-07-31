//
//  Extensions.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 31/07/25.
//

import UIKit

extension String {
    var removingHTMLTags: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributed.string
        } else {
            return self
        }
    }
}

