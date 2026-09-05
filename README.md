# English Adventure Kids v0.6

Cute offline English-learning game for ages 3–5, optimized conceptually for a Galaxy Tab S10.

## What's new in v0.5
- Replaced most emoji picture dependence with original SVG cartoon illustrations.
- Dog, Cat, Rabbit, Bird.
- Apple, Banana, Orange, Watermelon.
- Larger picture cards for tablet touch.
- Four short activities:
  - Listen & Find
  - Match Picture
  - Count
  - Colors
- Positive feedback only: no timer, no lives, no punishment.
- Local progress saved on the device.
- System Text-to-Speech is used for English pronunciation when available.
- Dedication:
  "Ba Diện gửi tới con Hồng Xiêm
   Chúc con luôn vui vẻ, mạnh khỏe, ngoan ngoãn và học giỏi!"

## Run
Open the folder in Godot 4.4.x and run `Main.tscn`.

## Android build
This version includes:
- `export_presets.cfg` with an Android preset.
- GitHub Actions workflow that downloads Godot 4.4.1 and Android export templates.
- Headless command-line APK export.
- ARM64 target, suitable for modern Android tablets such as Galaxy Tab S10.
- No Internet permission requested by the project.

Important: the workflow is intended for personal sideloading. Signing/build behavior should be verified by the first GitHub Actions run; a production-distribution signing key is not stored in this repository.
