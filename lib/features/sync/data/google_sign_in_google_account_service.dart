import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../domain/google_account_service.dart';
import '../domain/sync_models.dart';

class GoogleSignInGoogleAccountService implements GoogleAccountService {
  GoogleSignInGoogleAccountService({GoogleSignIn? googleSignIn})
    : _googleSignIn =
          googleSignIn ??
          GoogleSignIn(
            scopes: const ['https://www.googleapis.com/auth/drive.appdata'],
          );

  final GoogleSignIn _googleSignIn;

  @override
  bool get isSupported =>
      !kIsWeb &&
      defaultTargetPlatform != TargetPlatform.windows &&
      defaultTargetPlatform != TargetPlatform.linux &&
      defaultTargetPlatform != TargetPlatform.macOS;

  @override
  GoogleAccountIdentity? get currentAccount {
    final user = _googleSignIn.currentUser;
    if (user == null) {
      return null;
    }
    return GoogleAccountIdentity(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
    );
  }

  @override
  Future<GoogleAccountIdentity?> signIn() async {
    if (!isSupported) {
      return null;
    }
    final account = await _googleSignIn.signIn();
    return _mapAccount(account);
  }

  @override
  Future<GoogleAccountIdentity?> restoreSignIn() async {
    if (!isSupported) {
      return null;
    }
    final account = await _googleSignIn.signInSilently();
    return _mapAccount(account);
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  @override
  Future<http.Client?> createAuthenticatedClient() async {
    final account =
        _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
    if (account == null) {
      return null;
    }
    final authentication = await account.authentication;
    final accessToken = authentication.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }
    return _GoogleAuthClient(accessToken);
  }

  GoogleAccountIdentity? _mapAccount(GoogleSignInAccount? account) {
    if (account == null) {
      return null;
    }
    return GoogleAccountIdentity(
      id: account.id,
      email: account.email,
      displayName: account.displayName,
    );
  }
}

class _GoogleAuthClient extends http.BaseClient {
  _GoogleAuthClient(this._accessToken);

  final String _accessToken;
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
  }
}
