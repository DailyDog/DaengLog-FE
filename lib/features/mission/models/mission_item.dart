/// 미션 아이템 데이터 모델
/// 
/// 개별 미션 정보를 담는 데이터 모델입니다.
class MissionItem {
  /// 미션 ID
  final int id;
  
  /// 미션 제목 (예: "기분 알아보기", "산책", "가족 공유")
  final String title;
  
  /// 미션 설명
  final String description;
  
  /// 미션 아이콘 경로 (null일 경우 기본 아이콘 사용)
  final String? iconPath;
  
  /// 미션 보상 코인
  final int coinReward;
  
  /// 미션 완료 여부
  final bool isCompleted;
  
  /// 미션 타입 (예: "mood", "walk", "family_share")
  final String type;

  MissionItem({
    required this.id,
    required this.title,
    required this.description,
    this.iconPath,
    required this.coinReward,
    this.isCompleted = false,
    required this.type,
  });

  /// JSON 데이터로부터 MissionItem 생성
  factory MissionItem.fromJson(Map<String, dynamic> json) {
    return MissionItem(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String?,
      coinReward: json['coinReward'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      type: json['type'] as String,
    );
  }

  /// MissionItem을 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconPath': iconPath,
      'coinReward': coinReward,
      'isCompleted': isCompleted,
      'type': type,
    };
  }
}

