import 'package:http/http.dart' as http;

import 'sync_models.dart';

abstract interface class SyncService {
  Future<SyncExecutionResult> synchronize({
    required GoogleAccountIdentity account,
    required http.Client client,
    String? remoteFileId,
  });
}
