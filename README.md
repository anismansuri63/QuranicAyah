# QuranicAyah
# 📖 Quranic Ayah of the Day (iOS)

A beautifully simple iOS app that displays a **random daily verse (Ayah)** from the **Holy Quran**, along with its **English translation**, **Surah name**, and the ability to **listen to the verse** in Arabic. Users can also revisit previously shown ayahs in the **Archive**.

---

## 🌟 Features

- 🕋 **Daily Quranic Ayah** with:
  - Arabic text (Alafasy recitation)
  - English translation (Muhammad Asad edition)
  - Surah name
- 🔊 **Audio Playback** – Listen to the ayah in Arabic (with play button)
- 🔁 Refresh to load another random ayah
- 📜 Archive of previously shown ayahs
- 💾 Local storage using `UserDefaults`
- 📱 Built with SwiftUI (iOS 15+)

---

## 📸 Screenshots

| Today's Ayah | Archive |
|--------------|---------|
| ![Ayah](./screenshots/today.png) | ![Archive](./screenshots/archive.png) |

---

## 🧑‍💻 Tech Stack

- **Swift 5**
- **SwiftUI**
- **Combine**
- **AVFoundation** – for audio playback
- **UserDefaults** for local storage
- **AlQuran Cloud API** ([https://alquran.cloud/api](https://alquran.cloud/api))

---

## 🧾 API Usage

The app uses the [AlQuran Cloud API](https://alquran.cloud/api) to fetch:

- Arabic Text:  
  `https://api.alquran.cloud/v1/ayah/{ayahNumber}/ar.alafasy`
- English Translation:  
  `https://api.alquran.cloud/v1/ayah/{ayahNumber}/en.asad`
- Audio URL:  
  The `AyahData.audio` property provides the URL for Arabic recitation.

---
📌 TODO (Optional Enhancements)
 Add Tafsir per ayah (via another API)

 Daily Notification with Ayah

 Bookmark favorite ayahs

 Support for multiple translations

 Share ayah as image
 

🤲 Contribution
Feel free to open issues, suggest improvements, or submit pull requests 🙌

📬 Contact
Made with love and faith by Anis Mansuri

📧 Email: anismansuri63@gmail.com

🧑‍💼 LinkedIn: linkedin.com/in/anismansuri63


