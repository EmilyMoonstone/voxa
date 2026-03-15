import 'sync_models.dart';

abstract interface class SyncSnapshotCodec {
  String encode(SyncSnapshot snapshot);
  SyncSnapshot decode(String content);
}
