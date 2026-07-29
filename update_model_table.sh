#!/usr/bin/env bash
# ============================================================
# update_model_table.sh
# 每日以 Claude Code headless 模式更新 AI 模型比較表
# 建議由 cron 於每天早上 8:00 呼叫
# ============================================================
set -euo pipefail

# ── 設定（依你的環境修改這三行）─────────────────────────────
WORKDIR="$HOME/ai-model-table"          # HTML 與提示詞所在目錄
HTML_FILE="2026-ai-model-comparison.html"
CLAUDE_BIN="$(command -v claude || echo "$HOME/.local/bin/claude")"
TG_TOKEN_FILE="$WORKDIR/.telegram_token"
TG_CHATID_FILE="$WORKDIR/.telegram_chat_id"

# ── 準備 ────────────────────────────────────────────────────
cd "$WORKDIR"
LOGDIR="$WORKDIR/logs"
BACKUPDIR="$WORKDIR/backups"
mkdir -p "$LOGDIR" "$BACKUPDIR"
TODAY="$(date +%Y-%m-%d)"
LOGFILE="$LOGDIR/update-$TODAY.log"

# 檔案不存在就直接失敗，避免 Claude 憑空生一份
if [[ ! -f "$HTML_FILE" ]]; then
  echo "[ERROR] $HTML_FILE not found in $WORKDIR" | tee -a "$LOGFILE"
  exit 1
fi

# 每次執行前先備份（保留最近 14 份）
cp "$HTML_FILE" "$BACKUPDIR/${HTML_FILE%.html}-$TODAY.html"
ls -1t "$BACKUPDIR" | tail -n +15 | while read -r f; do rm -f "$BACKUPDIR/$f"; done

# ── 執行 Claude Code（headless）─────────────────────────────
# -p                : 非互動模式，跑完即退出
# --allowedTools    : 只授權必要工具，避免無人值守時做出範圍外的事
# --max-turns       : 限制回合數，控制單次成本上限
# --output-format   : JSON 輸出方便日後解析
echo "[$(date '+%F %T')] run start" >> "$LOGFILE"

"$CLAUDE_BIN" -p "$(cat update_prompt.md)" \
  --allowedTools "Read,Edit,Write,WebSearch,WebFetch" \
  --max-turns 40 \
  --output-format json \
  > "$LOGDIR/result-$TODAY.json" \
  2>> "$LOGFILE"

STATUS=$?
echo "[$(date '+%F %T')] run end, exit=$STATUS" >> "$LOGFILE"

# ── 簡單驗證：更新後檔案仍是合法 HTML 且沒被清空 ──────────────
if [[ ! -s "$HTML_FILE" ]] || ! grep -q "</html>" "$HTML_FILE"; then
  echo "[ERROR] HTML looks broken, restoring backup" | tee -a "$LOGFILE"
  cp "$BACKUPDIR/${HTML_FILE%.html}-$TODAY.html" "$HTML_FILE"
  exit 1
fi

# ── 傳送更新結果到 Telegram（HTML 檔 + 文字摘要）──────────────
if [[ $STATUS -eq 0 && -f "$TG_TOKEN_FILE" && -f "$TG_CHATID_FILE" ]]; then
  TG_TOKEN="$(cat "$TG_TOKEN_FILE")"
  TG_CHATID="$(cat "$TG_CHATID_FILE")"
  SUMMARY="$(jq -r '.result' "$LOGDIR/result-$TODAY.json" 2>>"$LOGFILE" || echo "(無法讀取摘要，詳見 log)")"

  if curl -s -F "chat_id=${TG_CHATID}" \
       -F "document=@${HTML_FILE}" \
       -F "caption=📊 AI 模型比較表更新 $TODAY
${SUMMARY}" \
       "https://api.telegram.org/bot${TG_TOKEN}/sendDocument" \
       >> "$LOGFILE" 2>&1; then
    echo "[$(date '+%F %T')] telegram sent" >> "$LOGFILE"
  else
    echo "[$(date '+%F %T')] telegram send FAILED (non-fatal)" >> "$LOGFILE"
  fi
else
  echo "[$(date '+%F %T')] telegram skipped (status=$STATUS or token/chatid file missing)" >> "$LOGFILE"
fi

exit $STATUS
