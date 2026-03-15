import 'dart:convert';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

import '../domain/cloud_sync_repository.dart';
import '../domain/sync_models.dart';

class GoogleDriveAppDataCloudSyncRepository implements CloudSyncRepository {
  static const _fileName = 'voxa_sync_v1.json';

  @override
  Future<CloudSyncDocument?> downloadSnapshot({
    required http.Client client,
  }) async {
    final api = drive.DriveApi(client);
    final files = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$_fileName' and trashed = false",
      $fields: 'files(id, version)',
      pageSize: 1,
    );
    final file = files.files?.firstOrNull;
    if (file?.id == null) {
      return null;
    }

    final media = await api.files.get(
      file!.id!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    );
    final streamed = media as drive.Media;
    final bytes = await streamed.stream.expand((chunk) => chunk).toList();
    return CloudSyncDocument(
      fileId: file.id!,
      content: utf8.decode(bytes),
      revision: file.version?.toString(),
    );
  }

  @override
  Future<UploadedSyncDocument> uploadSnapshot({
    required http.Client client,
    required String content,
    String? fileId,
  }) async {
    final api = drive.DriveApi(client);
    final media = drive.Media(
      Stream<List<int>>.value(utf8.encode(content)),
      utf8.encode(content).length,
      contentType: 'application/json',
    );
    final file = drive.File()..name = _fileName;
    drive.File response;
    if (fileId == null) {
      file.parents = ['appDataFolder'];
      response = await api.files.create(
        file,
        uploadMedia: media,
        $fields: 'id, version',
      );
    } else {
      response = await api.files.update(
        file,
        fileId,
        uploadMedia: media,
        $fields: 'id, version',
      );
    }
    return UploadedSyncDocument(
      fileId: response.id!,
      revision: response.version?.toString(),
    );
  }
}
