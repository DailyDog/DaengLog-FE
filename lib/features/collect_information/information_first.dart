import 'package:flutter/material.dart';

class InformationFirst extends StatefulWidget {
  const InformationFirst({Key? key}) : super(key: key);

  @override
  State<InformationFirst> createState() => _InformationFirstState();
}

// _의 의미 : 클래스 내부에서만 사용하는 클래스
class _InformationFirstState extends State<InformationFirst> {
  int? selectedIndex;

  final List<String> petTypes = [
    '강아지',
    '고양이',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 패턴 (간단한 예시)
          Positioned.fill(
            child: Opacity(
              opacity: 0.07,
              child: Image.asset(
                'assets/images/info_background.png', // 연한 패턴 이미지 준비 필요
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // 상단 진행 바
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5F01),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // 강조 텍스트
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '반려동물의 '),
                      TextSpan(
                        text: '종류',
                        style: TextStyle(color: Color(0xFFFF5F01)),
                      ),
                      TextSpan(text: '를 선택해 주세요!'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'AI에게 전달되는 정보에요.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                // 선택 버튼
                ...List.generate(petTypes.length, (index) {
                  final isSelected = selectedIndex == index;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color(0xFFFF5F01)
                            : Colors.grey[200],
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black87,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Text(
                        petTypes[index],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Row(
                    children: [
                      // 이전 버튼 (테두리만)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF5F01)),
                            foregroundColor: const Color(0xFFFF5F01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child:
                              const Text('이전', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 다음 버튼 (채움)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedIndex != null
                              ? () {
                                  Navigator.pushNamed(context, '/information_sec');
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5F01),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: const Text('다음', style: TextStyle(fontSize: 18, fontFamily: 'Pretendard', fontWeight: FontWeight.w400)),
                        ), 
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
