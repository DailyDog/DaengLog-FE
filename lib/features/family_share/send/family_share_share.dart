import 'package:flutter/material.dart';
import 'package:daenglog_fe/common/widgets/family_share/share_bottom.dart';

class FamilyShareScreen extends StatefulWidget {
  final String sharedContent;
  final String? sharedImagePath;
  
  const FamilyShareScreen({
    Key? key,
    required this.sharedContent,
    this.sharedImagePath,
  }) : super(key: key);

  @override
  State<FamilyShareScreen> createState() => _FamilyShareScreenState();
}

class _FamilyShareScreenState extends State<FamilyShareScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _selectedMembers = [];
  
  final List<Map<String, String>> _familyMembers = [
    {'name': '아빠', 'relation': 'Dad'},
    {'name': '누나', 'relation': 'Older Sister'},
    {'name': '엄마', 'relation': 'Mom'},
    {'name': '형', 'relation': 'Older Brother'},
  ];

  void _toggleMemberSelection(String memberName) {
    setState(() {
      if (_selectedMembers.contains(memberName)) {
        _selectedMembers.remove(memberName);
      } else {
        _selectedMembers.add(memberName);
      }
    });
  }

  void _sendMessage() {
    if (_selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('전송할 구성원을 선택해주세요')),
      );
      return;
    }
    
    // 전송 로직 구현
    print('Selected members: $_selectedMembers');
    print('Message: ${_messageController.text}');
    print('Shared content: ${widget.sharedContent}');
    
    // 성공 메시지 표시 후 바텀 시트 닫기
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('전송되었습니다!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // 연한 주황색 배경
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들 바
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCCCCCC),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 제목
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              '전송할 구성원을 선택하세요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF272727),
              ),
            ),
          ),
          
          // 구성원 선택
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _familyMembers.map((member) {
                final isSelected = _selectedMembers.contains(member['name']);
                return GestureDetector(
                  onTap: () => _toggleMemberSelection(member['name']!),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? const Color(0xFFFF6600) : const Color(0xFFF0F0F0),
                          border: isSelected 
                            ? Border.all(color: const Color(0xFFFF6600), width: 2)
                            : null,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: isSelected ? Colors.white : const Color(0xFF999999),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        member['name']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? const Color(0xFFFF6600) : const Color(0xFF272727),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 메시지 입력 및 전송
          ShareBottomWidget(
            messageController: _messageController,
            onSendPressed: _sendMessage,
            selectedMembersCount: _selectedMembers.length,
          ),
          
          // 하단 안전 영역
          Container(
            height: MediaQuery.of(context).padding.bottom,
            color: Color(0xFFFFF5F0), // 원하는 색상
          )
        ],
      ),
    );
  }
} 