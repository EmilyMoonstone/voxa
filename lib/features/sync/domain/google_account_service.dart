import 'package:http/http.dart' as http;

import 'sync_models.dart';

abstract interface class GoogleAccountService {
  bool get isSupported;
  GoogleAccountIdentity? get currentAccount;

  Future<GoogleAccountIdentity?> signIn();
  Future<GoogleAccountIdentity?> restoreSignIn();
  Future<void> signOut();
  Future<http.Client?> createAuthenticatedClient();
}
