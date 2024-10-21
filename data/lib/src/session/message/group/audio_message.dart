import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

import '../../../network/model/message/abstract_group_message.dart';
import '../../converter/uint8_list_converter.dart';

part 'audio_message.g.dart';

@JsonSerializable()
class AudioMessage extends AbstractGroupMessage {
  static const String type = 'audio';

  @Uint8ListConverter()
  final Uint8List audioData;

  AudioMessage(this.audioData);

  @override
  String getType() => type;

  @override
  Map<String, dynamic> toJson() {
    return _$AudioMessageToJson(this);
  }

  factory AudioMessage.fromJson(Map<String, dynamic> json) => _$AudioMessageFromJson(json);
}