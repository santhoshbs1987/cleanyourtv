# CleanYourTV: Xiaomi MiTV4I Setup Guide

Tested and applied on **Xiaomi MiTV4I** (`magnolia`), Android TV 9 (SDK 28), firmware `PI.3698 release-keys`.

---

## 1. What Was Done

1. **Full Device Backup**
   - Package lists, disabled package records, `getprop`, and system/global/secure settings backed up to the `backup/` directory.

2. **Debloat (29 Packages Disabled)**
   - **Xiaomi & Google Telemetry:** `com.miui.tv.analytics`, `com.xiaomi.statistic`, `com.google.android.feedback`, `com.google.android.tv.bugreportsender`, `com.xiaomo.tv.milegal`.
   - **Partner Auto-installs:** `android.autoinstalls.config.xiaomi.amelie`, `android.autoinstalls.config.xioami.dangal`, `com.xiaomi.android.tvsetup.partnercustomizer`.
   - **PatchWall & Promos:** `com.mitv.tvhome.atv`, `com.mitv.tvhome.mitvplus`, `com.mitv.tvhome.oemtab`, `com.xm.webcontent`, `co.sensara.tv.mitv`, `co.sensara.tv.mitv.res`, `com.google.android.tvrecommendations`, `com.google.android.leanbacklauncher.recommendations`.
   - **Background Cleaners & Services:** `com.xiaomi.mitv.tvmanager`, `com.xiaomi.mitv.updateservice`, `com.mitv.milinkservice`, `com.google.android.katniss`, `com.google.android.speech.pumpkin`, `com.google.android.backdrop`, `com.mitv.tvlock`, `com.google.android.marvin.talkback`.
   - **Unused Preloaded Apps:** `com.xiaomi.mimusic2`, `com.google.android.play.games`, `com.google.android.videos`.
   - **Stock Launchers:** `com.google.android.tvlauncher`, `com.google.android.leanbacklauncher`.

3. **Kept Apps & Services (Preserved based on your choices)**
   - **Live TV & Hardware Inputs:** `com.android.tv` (Live TV), `com.droidlogic.tvinput` (HDMI 1–3, AV), `com.droidlogic.droidlivetv`.
   - **Streaming & Media:** YouTube (`com.google.android.youtube.tv`), YouTube Music (`com.google.android.youtube.tvmusic`), Prime Video (`com.amazon.amazonvideo.livingroom`), Media Player (`com.xiaomi.mitv.mediaexplorer`), Mi Gallery (`com.mitv.gallery`), Mi Video (`com.mitv.videoplayer`).
   - **Casting & Core OS:** Chromecast built-in (`com.google.android.apps.mediashell`), Gboard, Google Play Store, Play Services, and setup wizard (`com.google.android.tungsten.setupwraith`, which maintains your Wi-Fi credentials).

4. **Apple TV 4K Launcher (CleanYourTV)**
   - Pitch black background.
   - Rounded frosted dock with 4 apps: **Live TV**, **YouTube**, **Prime Video**, **Media Player**.
   - Dynamic ambient glow sampled from the focused app's banner/colors.
   - Top bar with thin clock/date (Outfit font) and frosted glass pills for **Inputs**, **Wi-Fi** (displaying network name), and **Settings**.
   - Glass dropdown under Inputs for one-click switching between HDMI1, HDMI2, HDMI3, AV, and Live TV.

---

## 2. How to Re-enable Any App or Restore

### Re-enabling a Single App
Run over ADB:
```bash
tools/venv/bin/python3 tools/tv.py "pm enable <package_name>"
```
Examples:
- Re-enable Xiaomi Update Service:
  ```bash
  tools/venv/bin/python3 tools/tv.py "pm enable com.xiaomi.mitv.updateservice"
  ```
- Re-enable Google Assistant (voice remote):
  ```bash
  tools/venv/bin/python3 tools/tv.py "pm enable com.google.android.katniss"
  tools/venv/bin/python3 tools/tv.py "pm enable com.google.android.speech.pumpkin"
  ```

### Full Restore Script
To re-enable every disabled package and restore the stock Google TV launcher as Home:
```bash
./work/restore_mitv4i.sh
```

---

## 3. How to Change Dock Order or Wallpapers

### Changing Dock Apps
Edit `launcher/app/src/main/res/values/config.xml`:
```xml
<string-array name="dock_apps">
    <item>com.android.tv</item>
    <item>com.google.android.youtube.tv</item>
    <item>com.amazon.amazonvideo.livingroom</item>
    <item>com.xiaomi.mitv.mediaexplorer</item>
</string-array>
```
Then reinstall with:
```bash
cd launcher && TV_HOST=10.167.27.254:5555 ./build-and-install.sh
```

### Changing Themes or Setting Wallpapers
You can push themes and wallpapers dynamically without recompiling:
```bash
# Push the dark navy glass theme:
TV_HOST=10.167.27.254:5555 tools/theme.sh themes/glass

# Push the aurora theme:
TV_HOST=10.167.27.254:5555 tools/theme.sh themes/aurora

# Reset back to built-in pure black Apple TV style:
TV_HOST=10.167.27.254:5555 tools/theme.sh --reset
```

---

## 4. Final Security Step: Closing ADB

Leaving port 5555 open on a local network is a security risk. To close ADB:
1. On your TV remote, go to **Settings > Device Preferences > Developer options**.
2. Switch **USB debugging** to **OFF**.
3. Select **Revoke USB debugging authorisations** and confirm.
4. Restart the TV once.
5. Verify port 5555 is closed by running:
   ```bash
   python3 tools/adb-closed.py 10.167.27.254
   ```
