# Google Sync Setup

Voxa uses Google Sign-In plus Google Drive `appDataFolder` for metadata sync.

## Required setup

1. Create or reuse a Google Cloud project.
2. Enable the **Google Drive API**.
3. Create OAuth client ids for:
   - Android app `de.bruckcode.voxa`
   - iOS app `de.bruckcode.voxa`
4. Register the Android SHA-1 / SHA-256 signing fingerprints.
5. Add the iOS URL scheme / client id configuration required by `google_sign_in`.

## Android signing setup

Voxa supports a dedicated release keystore via `android/key.properties`.

1. Copy `android/key.properties.example` to `android/key.properties`.
2. Fill in:
   - `storePassword`
   - `keyPassword`
   - `keyAlias`
   - `storeFile`
3. For the current repo layout, `storeFile=../bruckcode.jks` points to the root-level keystore.
4. Once `key.properties` is present, Android release builds will use that keystore automatically.
5. If `key.properties` is missing, release builds fall back to the debug keystore for local testing only.

## Android troubleshooting

If Google sign-in fails with:

- `PlatformException(sign_in_failed, ... ApiException: 10 ...)`

then the Android OAuth client is misconfigured.

Check all of the following:

1. The Android OAuth client in Google Cloud uses package name `de.bruckcode.voxa`.
2. The SHA-1 and SHA-256 fingerprints match the keystore used for the current build.
3. If you run a debug build from Flutter, the debug keystore fingerprint must be registered on the debug Android client.
4. If you run a release build with `bruckcode.jks`, the release signing fingerprint must be registered on the release Android client.
5. If the package name was changed from an earlier value, create/update the OAuth client for the new package name.
6. After changing the Google Cloud config, reinstall the app or clear app data before retrying sign-in.

`ApiException: 10` is a Google configuration error, not a Voxa runtime logic error.

## What syncs

- app settings
- current target
- saved session summaries
- downsampled chart points
- analysis summaries

## What does not sync

- recorded audio files
- bundled practice texts

## Storage model

The sync file is stored in Google Drive's hidden `appDataFolder` as:

- `voxa_sync_v1.json`

Users do not see this file in normal Drive folders.
