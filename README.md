### 🐻‍❄️🍃 Noelware | Bazel Registry
This repository contains the Bazel Module Registry hosted on GitHub for modifications and Noelware's own Bazel modules.

## Modified Modules
The following Bazel modules specified have been modified for our own use-cases, all versions will have a `.noelware` suffix appended for each revision to not confuse users.

| Module           | Reasoning |
| :--------------- | --------- |
| [`tomlplusplus`] | Providing knobs for TOML++-specific features like enabling pedantic C++ flags, the use of `-fno-exceptions`, and unreleased TOML features. |
| [`cpp-httplib`]  | Occasionally bumps **cpp-httplib** to the latest version and provides Bazel 9 support |
| [`curl`]         | Upgrading `cURL` to the latest version. As of April 1st, 2026, the `curl` Bazel Module hosted on the BCR is stuck at 8.12.0 |

[`tomlplusplus`]: https://registry.bazel.build/modules/tomlplusplus
[`cpp-httplib`]: https://registry.bazel.build/modules/cpp-httplib
[`curl`]: https://registry.bazel.build/modules/curl
