import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';
import 'package:image_picker/image_picker.dart';

/// 채팅 메시지 모델
class ChatMessageModel {
  final bool isUser; // true: 사용자, false: GPT
  final String? text;
  final XFile? image;
  final DiaryGptResponse? gptResponse;

  /// 사용자 메시지
  ChatMessageModel.user({required this.text, required this.image})
      : isUser = true, gptResponse = null;
  /// GPT 메시지
  ChatMessageModel.gpt({required this.gptResponse})
      : isUser = false, text = null, image = null;
}