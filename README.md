### 🐻‍❄️🍃 Noelware | Bazel Registry
This repository contains the Bazel Module Registry hosted on GitHub for modifications and Noelware's own Bazel modules.

## Modified Modules
The following Bazel modules specified have been modified for our own use-cases, all versions will have a `.noelware` suffix appended for each revision to not confuse users.

| Module           | Reasoning |
| :--------------- | --------- |
| [`tomlplusplus`] | Providing knobs for TOML++-specific features like enabling pedantic C++ flags, the use of `-fno-exceptions`, and unreleased TOML features. |
| [`curl`]         | Upgrading `cURL` to the latest version. As of April 1st, 2026, the `curl` Bazel Module hosted on the BCR is stuck at 8.12.0 |
