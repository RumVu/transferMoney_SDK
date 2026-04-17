# Developer Tools

Use this page when maintaining the SDK, building the documentation site, or preparing a release.

## Build and test

Run the full test suite:

```bash
swift test
```

Preview the documentation locally:

```bash
swift package preview-documentation --target transferMoney_SDK
```

Generate static DocC output for deployment:

```bash
swift package --allow-writing-to-directory ./build-docs \
  generate-documentation \
  --target transferMoney_SDK \
  --output-path ./build-docs \
  --transform-for-static-hosting \
  --hosting-base-path transferMoney_SDK
```

## Swift Package Index

The repository includes a root `.spi.yml` file so Swift Package Index knows which target contains the DocC documentation.

SPI handles versioned documentation from Git tags. Once a semver tag such as `v0.0.9` is pushed, the package page can build a docs snapshot for that version and expose the version picker automatically.

## Release workflow

The package ships with a `release.sh` helper:

```bash
./release.sh 0.0.9
```

Expected workflow:

1. Update version references in source and tests.
2. Run `swift test`.
3. Commit release changes.
4. Create tag `v<version>`.
5. Push branch and tags.

## Deployment notes

- Keep authored markdown guides in the DocC catalog under `Sources/transferMoney_SDK/transferMoney_SDK.docc`.
- Keep generated static output in `build-docs/`.
- Do not mix generated files back into the authored docs source tree.
