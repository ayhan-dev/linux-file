#!/bin/bash
if [ -z "$1" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Please specify the path to the .env file." >> /tmp/error.log
  exit 1
fi
ENV_FILE=$1
if [ ! -f "$ENV_FILE" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: .env file not found at $ENV_FILE" >> /tmp/error.log
  exit 1
fi
export $(grep -v '^#' "$ENV_FILE" | xargs)
if [ -z "$TAR_DIR" ] || [ -z "$DAYS" ] || [ -z "$LOG_FILE" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Missing required parameters in .env (TAR_DIR, DAYS or LOG_FILE)" >> /tmp/error.log
  exit 1
fi
if [ ! -d "$TAR_DIR" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Target directory not found: $TAR_DIR" >> "$LOG_FILE"
  exit 1
fi
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting cleanup: deleting files older than $DAYS days in $TAR_DIR" >> "$LOG_FILE"
DELETED_FILES=$(find "$TAR_DIR" -type f -mtime +$DAYS -exec rm -v {} \; 2>>"$LOG_FILE")
if [ -z "$DELETED_FILES" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleanup completed. No files were deleted." >> "$LOG_FILE"
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cleanup completed. Deleted files:" >> "$LOG_FILE"
  echo "$DELETED_FILES" >> "$LOG_FILE"
fi
