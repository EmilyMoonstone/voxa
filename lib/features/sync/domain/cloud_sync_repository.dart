import 'package:http/http.dart' as http;

import 'sync_models.dart';

abstract interface class CloudSyncRepository {
  Future<CloudSyncDocument?> downloadSnapshot({required http.Client client});

  Future<UploadedSyncDocument> uploadSnapshot({
    required http.Client client,
    required String content,
    String? fileId,
  });
}
