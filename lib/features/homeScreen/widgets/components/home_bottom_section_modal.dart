import 'package:daenglog_fe/features/homeScreen/models/home_widget_item.dart';
import 'package:flutter/material.dart';

// 위젯 선택 모달
class HomeBottomSectionModal extends StatefulWidget {
  final List<HomeWidgetItem> availableWidgets;
  final List<String> selectedWidgets;
  final Function(List<String>) onSelectionChanged;

  const HomeBottomSectionModal({
    required this.availableWidgets,
    required this.selectedWidgets,
    required this.onSelectionChanged,
  });

  @override
  State<HomeBottomSectionModal> createState() => _HomeBottomSectionModalState();
}

class _HomeBottomSectionModalState extends State<HomeBottomSectionModal> {
  late List<String> tempSelectedWidgets;

  @override
  void initState() {
    super.initState();
    tempSelectedWidgets = List.from(widget.selectedWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 제목
            const Text(
              '위젯을 자유롭게 설정해보세요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '원하는 위젯을 선택하여 홈 화면에 표시하세요.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // 위젯 선택 그리드
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: widget.availableWidgets.length,
              itemBuilder: (context, index) {
                final widgetItem = widget.availableWidgets[index];
                final isSelected = tempSelectedWidgets.contains(widgetItem.id);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        tempSelectedWidgets.remove(widgetItem.id);
                      } else {
                        if (!tempSelectedWidgets.contains(widgetItem.id)) {
                          tempSelectedWidgets.add(widgetItem.id);
                        }
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
                    ),
                    child: Stack(
                      children: [
                        // 체크 표시
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        
                        // 위젯 내용
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                widgetItem.iconPath!,
                                width: 20,
                                height: 20,
                                color: isSelected ? Colors.blue : Colors.grey,
                               
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widgetItem.title,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? Colors.blue : Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            
            // 버튼들
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('닫기'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSelectionChanged(tempSelectedWidgets);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '선택 완료',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}