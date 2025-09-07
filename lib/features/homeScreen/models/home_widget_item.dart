// 위젯 아이템 모델
class HomeWidgetItem {
  final String id;
  final String title;
  final String description;
  final String? iconPath; 

  HomeWidgetItem({
    required this.id,
    required this.title,
    required this.description,
    this.iconPath,
  });
}