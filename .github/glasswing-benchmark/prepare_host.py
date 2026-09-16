#!/usr/bin/env python3

import argparse
from pathlib import Path

import yaml


def load(path: Path) -> dict:
    with path.open(encoding="utf-8") as handle:
        return yaml.safe_load(handle)


def save(path: Path, data: dict) -> None:
    with path.open("w", encoding="utf-8") as handle:
        yaml.safe_dump(data, handle, sort_keys=False, allow_unicode=True)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("plugin_name")
    parser.add_argument("plugin_root", type=Path)
    parser.add_argument("host_root", type=Path)
    args = parser.parse_args()

    plugin_pubspec = args.plugin_root / "pubspec.yaml"
    plugin = load(plugin_pubspec)
    plugin.setdefault("environment", {})["sdk"] = ">=2.19.0 <4.0.0"
    save(plugin_pubspec, plugin)

    host_pubspec = args.host_root / "pubspec.yaml"
    host = load(host_pubspec)
    host.setdefault("dependencies", {})[args.plugin_name] = {
        "path": str(args.plugin_root.resolve())
    }
    save(host_pubspec, host)

    app_gradle = args.host_root / "android" / "app" / "build.gradle"
    app_text = app_gradle.read_text(encoding="utf-8")
    expected_app_settings = (
        "compileSdkVersion flutter.compileSdkVersion",
        "minSdkVersion flutter.minSdkVersion",
    )
    missing_app_settings = [value for value in expected_app_settings if value not in app_text]
    if missing_app_settings:
        raise RuntimeError(f"Unexpected Flutter Android template: {missing_app_settings}")
    app_text = app_text.replace(
        "compileSdkVersion flutter.compileSdkVersion", "compileSdkVersion 34"
    )
    app_text = app_text.replace(
        "minSdkVersion flutter.minSdkVersion", "minSdkVersion 23"
    )
    app_gradle.write_text(app_text, encoding="utf-8")

    project_gradle = args.host_root / "android" / "build.gradle"
    project_text = project_gradle.read_text(encoding="utf-8")
    kotlin_setting = "ext.kotlin_version = '1.7.10'"
    if kotlin_setting not in project_text:
        raise RuntimeError("Unexpected Kotlin version in Flutter Android template")
    project_text = project_text.replace(
        kotlin_setting, "ext.kotlin_version = '1.9.24'"
    )
    project_gradle.write_text(project_text, encoding="utf-8")


if __name__ == "__main__":
    main()
