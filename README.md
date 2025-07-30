# QuranicAyah
# 📖 Quranic Ayah of the Day (iOS)

A beautifully simple iOS app that displays a **random daily verse (Ayah)** from the **Holy Quran**, along with its **English translation** and **Surah information**. Users can also revisit previously shown verses in the **Archive** section.

---

## 🌟 Features

- 🕋 Daily Quranic Ayah with:
  - Arabic text (from Alafasy edition)
  - English translation (Muhammad Asad edition)
  - Surah name
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
- **UserDefaults** for local storage
- **AlQuran Cloud API** ([https://alquran.cloud/api](https://alquran.cloud/api))

---

## 🧾 API Usage

The app uses the [AlQuran Cloud API](https://alquran.cloud/api) to fetch Quranic verses:

- Arabic Text: `https://api.alquran.cloud/v1/ayah/{ayahNumber}/ar.alafasy`
- English Translation: `https://api.alquran.cloud/v1/ayah/{ayahNumber}/en.asad`

Total number of ayahs = 6236. The app randomly selects one each time it is opened or refreshed.

---

## 🗂 Project Structure

