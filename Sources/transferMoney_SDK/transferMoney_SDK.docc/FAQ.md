# FAQ

## Which version should I use for a new project?

Start with `0.0.9`. It is the recommended stable release and includes the current documentation publishing setup.

## Which version should I use for an existing production app?

Prefer the version already validated by that app team. If you need a stable existing line, `0.0.8` is the safest previous release to pin with `exact:`.

## Does the SDK require internet access?

No. All calculations run locally.

## Can I choose a custom rate?

Yes. Use ``ConversionOption/customRate(_:)`` for one conversion or ``TransferMoney_core/updateExchangeRates(_:)`` to update the runtime configuration.

## How do developers view older documentation?

Push semver Git tags and let Swift Package Index build versioned DocC snapshots. The version picker comes from those published versions.

## Where should static DocC output go?

Generate it into `build-docs/` and keep the authored source content in the DocC catalog.
