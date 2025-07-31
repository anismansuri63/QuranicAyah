//
//  FullTafsirView.swift
//  QuranicAyah
//
//  Created by Anis Mansuri on 31/07/25.
//

import SwiftUI


struct FullTafsirView: View {
    let title: String
    let tafsirText: String
    @AppStorage("selectedFont") private var selectedFont: String = QuranFont.indopak.rawValue
    var body1: some View {
            ScrollView {
                if let attributed = try? AttributedString(
                    markdown: tafsirText,
                    options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .full)
                ) {
                    Text(attributed)
                        .font(.custom(selectedFont, size: 16))
                        .padding()
                } else {
                    Text(tafsirText) // fallback
                        .padding()
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }

    var body: some View {
        GeometryReader { geometry in
                    ScrollView {
                        HTMLTextView(html: tafsirText)
                            .frame(width: geometry.size.width - 32) // 16pt padding on each side
                            .padding()
                    }
                }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

struct HTMLTextView: UIViewRepresentable {
    let html: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        guard let data = html.data(using: .utf8) else {
            uiView.text = html
            return
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        if let attributedString = try? NSMutableAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) {
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.alignment = .natural

            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.font, value: UIFont(name: "AlQuranIndoPakbyQuranWBW", size: 18), range: NSRange(location: 0, length: attributedString.length))

            uiView.attributedText = attributedString
        } else {
            uiView.text = html
        }
    }
}

