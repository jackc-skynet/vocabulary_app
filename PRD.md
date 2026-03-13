# 產品需求規格書 (PRD)：英文單字瀏覽與發聲 App

## 1. 產品概述 (Product Overview)
本專案旨在開發一款專為 Android 系統設計的手機應用程式 (App)。其主要功能為提供使用者瀏覽英文單字、查看詳細解釋，並具備單字發音功能，以輔助使用者學習與記憶英文單字。

## 2. 目標受眾 (Target Audience)
* 正在學習英文的學生（國高中生、大學生）。
* 準備多益 (TOEIC)、托福 (TOEFL)、雅思 (IELTS) 等英文檢定考試的考生。
* 希望利用零碎時間提升英文單字量的上班族與一般大眾。

## 3. 核心功能需求 (Core Features)

### 3.1 單字瀏覽功能 (Word Browsing)
* **單字列表 (Word List)**：呈現英文單字清單，支援無限滾動或分頁顯示。
* **單字分類/字庫 (Categories/Vocabularies)**：允許使用者依照難易度（如：國中必備 2000 單字、多益核心單字）或類別（如：商業、生活、科技）來瀏覽單字。
* **搜尋功能 (Search)**：提供搜尋列，支援輸入英文單字或中文解釋來快速尋找特定單字。

### 3.2 單字解釋功能 (Word Explanation)
* **詳細資訊頁 (Word Detail)**：點擊單字後進入，顯示單字的完整資訊。
* **釋義內容 (Definitions)**：
  * 單字拼寫 (Word spelling)
  * 音標 (KK 音標或 IPA 國際音標)
  * 詞性 (名詞, 動詞, 形容詞等)
  * 中文解釋 (Chinese definitions)
  * 例句 (Example sentences) 及例句翻譯。

### 3.3 發聲功能 (Pronunciation / Text-to-Speech)
* **單字發音 (Word Audio)**：在單字列表及詳細資訊頁皆提供發音按鈕 (如喇叭圖示)，點擊後播放標準英文發音。
* **例句發音 (Example Sentence Audio)**：(選配/進階功能) 允許播放例句的整句發音。
* **發音來源 (Audio Source)**：優先使用 API 提供的音檔連結，若無則 fallback 至 Android/iOS 內建的 TextToSpeech (TTS) 引擎。

### 3.4 單字測驗功能 (Vocabulary Quiz)
* **測驗機制**：提供 10 題選擇題的測驗，驗證使用者對單字意義的掌握程度。
* **測驗內容**：每輪從已查詢過或精選單字庫中抽取 10 個單字。
* **結果記錄**：測驗結束後顯示正確題數，並將每次測驗的分數與日期記錄下來。

### 3.5 單字資料來源 (Data Source)
* **公開 API (Public API)**：串接免費的公開字典 API，例如 **[Free Dictionary API](https://dictionaryapi.dev/)**。
  * 優點：免費、無需 API Key、提供詳細解釋、音標及發音音檔連結。
  * 實作方式：App 啟動或搜尋時即時呼叫 API 獲取單字資料，或預先抓取常用單字庫存入本地端。

## 4. 非功能性需求 (Non-Functional Requirements)
* **開發技術 (Tech Stack)**：使用 **Flutter (Dart)** 進行跨平台開發。雖然初期目標為 Android，但使用 Flutter 可保留未來快速發布 iOS 版本的彈性，且具備優異的 UI 渲染效能。
* **目標作業系統 (Platform)**：Android (支援 Android 8.0 及以上版本)、(未來擴充) iOS 12.0+。
* **使用者介面 (UI/UX)**：介面設計需簡潔、易讀，按鈕大小適合手機點擊，支援淺色/深色模式 (Light/Dark mode) 以減少長時間閱讀的視覺疲勞。
* **效能 (Performance)**：單字列表滑動需順暢，音檔播放延遲需小於 0.5 秒。
* **離線支援 (Offline Support)**：(強烈建議) 單字庫與基本 TTS 發音應支援離線使用，確保無網路環境下仍能學習。

## 5. 未來擴充功能 (Future Enhancements / Phase 2)
* **我的最愛/單字卡 (Favorites / Flashcards)**：允許使用者將不熟的單字加入書籤，集中複習。
* **每日單字推播 (Daily Push Notifications)**：每天定時推播幾個單字，提醒使用者學習。
* **生字筆記 (User Notes)**：允許使用者對特定單字加上自己的筆記或記憶口訣。

---
**文件狀態：** 草案 (Draft)
**建立日期：** 2026-03-11
