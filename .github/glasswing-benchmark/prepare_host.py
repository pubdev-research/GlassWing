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


if __name__ == "__main__":
    main()
