// 주간 일기 모델
class Weekly {
  final String? additionalProperties;

  Weekly({
    required this.additionalProperties,
  });

  factory Weekly.fromJson(Map<String, dynamic> json) {
    return Weekly(
      additionalProperties: json['addtionalProp'],
    );
  }
}