class MyInfoModel {
  final int id;
  final String name;
  final String email;
  final String birthDate; // yyyy-MM-dd
  final bool termsAgreed;
  final String provider; // GOOGLE, NAVER, APPLE ...
  final String planCode;

  MyInfoModel({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.termsAgreed,
    required this.provider,
    required this.planCode,
  });

  factory MyInfoModel.fromJson(Map<String, dynamic> json) {
    return MyInfoModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      termsAgreed: json['termsAgreed'] as bool? ?? false,
      provider: json['provider'] as String? ?? '',
      planCode: json['planCode'] as String? ?? '',
    );
  }
}


