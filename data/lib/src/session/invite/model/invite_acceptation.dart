import 'package:pointycastle/asymmetric/api.dart';

import '../../../encryption/model/ingest_key.dart';

class InviteAcceptation {
  final String comparableCode;
  final String userUuid;
  final String username;
  final String groupUuid;
  final RSAPublicKey userPublicKey;
  final IngestKey ingestKey;

  InviteAcceptation(this.comparableCode, this.userUuid, this.username, this.groupUuid, this.userPublicKey, this.ingestKey);
}