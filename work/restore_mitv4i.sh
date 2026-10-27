#!/usr/bin/env bash
# Restore script for Xiaomi MiTV4I
# Re-enables all debloated packages and restores the stock launcher if desired.
set -euo pipefail

TV_HOST="${TV_HOST:-10.167.27.254:5555}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

PY="$REPO_DIR/tools/venv/bin/python"
[ -x "$PY" ] || PY=python3

echo "Connecting to $TV_HOST..."

PKGS=(
  com.miui.tv.analytics
  com.xiaomi.statistic
  com.google.android.feedback
  com.google.android.tv.bugreportsender
  com.xiaomo.tv.milegal
  android.autoinstalls.config.xiaomi.amelie
  android.autoinstalls.config.xioami.dangal
  com.xiaomi.android.tvsetup.partnercustomizer
  com.mitv.tvhome.atv
  com.mitv.tvhome.mitvplus
  com.mitv.tvhome.oemtab
  com.xm.webcontent
  co.sensara.tv.mitv
  co.sensara.tv.mitv.res
  com.google.android.tvrecommendations
  com.google.android.leanbacklauncher.recommendations
  com.xiaomi.mitv.tvmanager
  com.xiaomi.mitv.updateservice
  com.mitv.milinkservice
  com.google.android.katniss
  com.google.android.speech.pumpkin
  com.google.android.backdrop
  com.mitv.tvlock
  com.google.android.marvin.talkback
  com.xiaomi.mimusic2
  com.google.android.play.games
  com.google.android.videos
  com.google.android.tvlauncher
  com.google.android.leanbacklauncher
)

echo "Re-enabling packages..."
for pkg in "${PKGS[@]}"; do
  echo "Enabling $pkg..."
  TV_HOST="$TV_HOST" "$PY" "$REPO_DIR/tools/tv.py" "pm enable $pkg" || true
done

echo "Setting stock launcher as default Home..."
TV_HOST="$TV_HOST" "$PY" "$REPO_DIR/tools/tv.py" "cmd package set-home-activity com.google.android.tvlauncher/.MainActivity" || true

echo "Restoration complete! Checking disabled packages:"
TV_HOST="$TV_HOST" "$PY" "$REPO_DIR/tools/tv.py" "pm list packages -d --user 0"
