import 'package:data/src/encryption/model/ingest_key.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../network/model/message/abstract_direct_message.dart';


part 'introduce_self.g.dart';

@JsonSerializable()
class IntroduceSelf extends AbstractDirectMessage {
  static const String type = 'introduce_self';

  final IngestKey ingestKey;

  IntroduceSelf(this.ingestKey);

  @override
  String getType() => type;

  @override
  Map<String, dynamic> toJson() => _$IntroduceSelfToJson(this);

  factory IntroduceSelf.fromJson(Map<String, dynamic> json) => _$IntroduceSelfFromJson(json);
}