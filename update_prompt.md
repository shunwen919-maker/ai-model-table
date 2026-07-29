# 任務：更新 AI 模型比較表

你是一個每日排程執行的自動化任務。請更新工作目錄中的 `2026-ai-model-comparison.html`。

## 頁面結構（重要，先讀懂再改）

這是一個 React 互動頁（由 `dc-runtime.js` 驅動，**不要動 dc-runtime.js**）。HTML 分兩部分：

1. **模型資料**：在 `<script type="text/x-dc">` 內 `class Component extends DCLogic` 的 `get data()` 陣列中。每個模型是一筆 `m({ ... })`，欄位包括：
   - `id`（唯一代號）、`tier`（flagship／highend／workhorse／china／light）、`group`（anthropic／openai／google／xai／deepseek 等）
   - `name`、`vendor`、`color`（廠商圓點色）、`date`、`dateSort`（YYYYMMDD 數字）
   - `price`（如 `'$5 / $25'`）、`priceOut`（輸出價數字，供價格條計算）、`priceNote`
   - `statBig`／`statLabel`（大字跑分）、`cap`（能力說明）、`feat`（功能特色）
   - `bd`（Bedrock 狀態：ok／warn／no／unknown）、`bdNote`
   修改價格、跑分、Bedrock 狀態、新增或移除模型，都是編輯這個陣列。注意 JS 字串內的單引號要跳脫（`\'`）。

2. **靜態區塊**：hero、每日新聞（`<section id="news">`）、備註（`<section id="notes">`）、footer 是一般 HTML。

## 步驟

1. 先用 Read 讀取 `2026-ai-model-comparison.html`，了解現有結構。**不要改動整體版面、CSS、dc-runtime.js 或元件邏輯**，只更新資料與內容。

2. 用 WebSearch 搜尋以下主題的最新資訊（以今天日期為準）：
   - Anthropic Claude 最新模型發布（Opus、Sonnet、Fable、Haiku 系列）
   - OpenAI GPT 最新模型發布與定價
   - Google Gemini 最新模型（特別注意 Gemini 3.5 Pro 是否已正式發布）
   - xAI Grok 最新版本
   - 中國模型：DeepSeek、月之暗面 Kimi、阿里通義 Qwen、智譜 GLM、騰訊混元
   - Amazon Bedrock 新上架的模型（搜尋 "Amazon Bedrock new models" 加當月年份）

3. 比對搜尋結果與 `get data()` 現有內容，只在有「實質變化」時修改：
   - 新模型發布 → 在對應 `tier` 加一筆 `m({...})`（欄位格式沿用同層級現有項目）
   - 價格變動 → 更新 `price`、`priceOut`、`priceNote`
   - Bedrock 上架狀態變化 → 更新 `bd` 與 `bdNote`
   - 模型被取代或退場 → 可移除該筆或在 `feat`／`priceNote` 標示
   - 若模型總數有增減 → 同步更新 hero 中「N 款模型，5 個層級」的數字

4. 更新「AI 模型每日新聞」區塊（`<section id="news">`）：

   用 WebFetch / WebSearch 檢查以下來源今天（以系統日期為準）的最新內容：
   - https://www.anthropic.com/news （Claude 新模型/功能）
   - https://openai.com/news （OpenAI 公告）
   - https://blog.google/technology/ai/ （Gemini 發布）
   - https://x.ai/news （Grok 發布）
   - https://aws.amazon.com/about-aws/whats-new/?whats-new-content-all.q=bedrock （Bedrock 新上架模型）
   - https://api-docs.deepseek.com/news （DeepSeek）
   - https://artificialanalysis.ai （排行榜與價格變動）
   - https://lmarena.ai （使用者偏好排名變動）
   - https://github.com/trending?since=daily （開源模型動態，關注 deepseek-ai、QwenLM、MoonshotAI、zai-org）
   - https://news.ycombinator.com （重大 AI 模型消息）

   然後**整段改寫**（不是累加）news 區塊的內容，沿用現有 HTML 結構：
   - 標題下方 `<p>` 的日期改為今天（YYYY-MM-DD 更新）
   - 五個分類列依序為：新模型發布、價格與排名變動、Bedrock 上架動態、中國模型動態、其他值得注意（最多 3 條）
   - 每條 `<p>` 末尾附來源連結 `<a href="..." target="_blank" rel="noopener">來源</a>`
   - 某分類沒有新消息 → `<p style="margin:0;font-size:15px;color:#a1a1a6;line-height:1.65">今日無。</p>`
   - 只寫最近 2 天內的新消息；不確定的標「未確認」，不要編造

5. 無論有無變動，都要更新：
   - hero 中「FRONTIER MODEL INDEX · YYYY.MM.DD」的日期
   - news 區塊的「YYYY-MM-DD 更新」
   - `<footer>` 中的「資料整理日期」

6. 更新完成後，在最後輸出一段純文字摘要（3 行以內）：今天有哪些重點，或「無實質變化，僅更新日期」。

## 規則

- 只信任官方來源或可靠科技媒體；跑分要註明出自官方發布資料
- 不確定的資訊寧可標「未確認」也不要編造
- 價格一律以「美元 / 每百萬 tokens（輸入/輸出）」表示
- 保持繁體中文
- 不要刪除備註區塊（`<section id="notes">`）的既有免責說明
- 改完後確認 `<script type="text/x-dc">` 內的 JS 語法有效（括號、引號、逗號配對），語法錯誤會讓整頁掛掉
