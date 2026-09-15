# Running GlassWing on macOS ARM64

GlassWing's bundled `artifacts/coreir_processor` is a macOS ARM64 Mach-O
executable. It cannot run in a Linux Docker container because containers share
the Linux host kernel. The workflow in
`.github/workflows/glasswing-macos-arm64.yml` runs the complete Core and Raw
pipelines on GitHub's Apple Silicon `macos-15` runner.

## Run the workflow

1. Push this repository to a GitHub fork or another repository with Actions
   enabled.
2. Open **Actions > GlassWing macOS ARM64 > Run workflow**.
3. Leave `apk_url` empty to build and analyze the included smoke app, or enter
   a direct HTTPS URL to an APK that contains `lib/arm64-v8a`.
4. Download the `glasswing-results-*` artifact after the job finishes.

The result artifact contains the generated Blutter output, CoreIR files, Core
and Raw FlowDroid results, generated configurations, and the complete run log.
The workflow pins Android API 30, Python 3.10, and Java 17 for reproducibility.

## Local Apple Silicon Mac

The same driver can be used on an Apple Silicon Mac after setting the Android
platform JAR explicitly:

```bash
export GLASSWING_ANDROID_JAR="$ANDROID_HOME/platforms/android-30/android.jar"
python3 artifacts/flutter_apk_analyzer.py /path/to/apkdir /path/to/outdir
```

Each APK must include the Flutter AOT libraries under `lib/arm64-v8a`.
