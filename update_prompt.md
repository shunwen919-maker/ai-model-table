# 任務：更新 AI 模型比較表

你是一個每日排程執行的自動化任務。請更新工作目錄中的 `2026-ai-model-comparison.html`。

## 步驟

1. 先用 Read 讀取 `2026-ai-model-comparison.html`，了解現有結構、涵蓋的模型與各欄位格式。**不要改動整體 HTML 結構、CSS 或版面設計**，只更新內容。

2. 用 WebSearch 搜尋以下主題的最新資訊（以今天日期為準）：
   - Anthropic Claude 最新模型發布（Opus、Sonnet、Fable、Haiku 系列）
   - OpenAI GPT 最新模型發布與定價
   - Google Gemini 最新模型（特別注意 Gemini 3.5 Pro 是否已正式發布）
   - xAI Grok 最新版本
   - 中國模型：DeepSeek、月之暗面 Kimi、阿里通義 Qwen、智譜 GLM、騰訊混元
   - Amazon Bedrock 新上架的模型（搜尋 "Amazon Bedrock new models" 加當月年份）

3. 比對搜尋結果與現有表格內容，只在有「實質變化」時修改：
   - 新模型發布 → 加入對應層級的表格（沿用現有 `<tr>` 格式，包含 vendor dot、價格條、badge）
   - 價格變動 → 更新價格欄與 costbar 寬度（costbar 以輸出價 $50/M 為 100%）
   - Bedrock 上架狀態變化 → 更新 badge（ok=已支援、warn=部分支援、no=不支援、unknown=尚未確認）
   - 模型被取代或退場 → 可移除或在備註中標示
   - 優惠價到期（如 Sonnet 5 的 8/31 期限）→ 更新為正式價格

4. 無論有無變動，都要更新：
   - `<div class="stamp">` 中的日期
   - `<footer>` 中的「資料整理日期」

5. 更新完成後，在最後輸出一段純文字摘要（3 行以內）：今天更新了什麼，或「無實質變化，僅更新日期」。

## 規則

- 只信任官方來源或可靠科技媒體；跑分要註明出自官方發布資料
- 不確定的資訊寧可標「未確認」也不要編造
- 價格一律以「美元 / 每百萬 tokens（輸入/輸出）」表示
- 保持繁體中文
- 不要刪除備註區塊（.notes）的既有免責說明
