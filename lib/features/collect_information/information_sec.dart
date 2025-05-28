import 'package:flutter/material.dart';

class InformationSec extends StatefulWidget {
  const InformationSec({Key? key}) : super(key: key);

  @override
  State<InformationSec> createState() => _InformationSecState();
}

class _InformationSecState extends State<InformationSec> {
  int selectedIndex = 0;

  final List<String> petTypes = [
    '강아지',
    '고양이',
    '물고기',
    '햄스터',
    '토끼',
    '기타',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              '반려동물의 종류를 선택해주세요!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AI에게 전달되는 정보에요!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ...List.generate(petTypes.length, (index) {
              final isSelected = selectedIndex == index;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.orange : Colors.grey[200],
                    foregroundColor: isSelected ? Colors.white : Colors.black54,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
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
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 이전 버튼 동작
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text('이전'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 다음 버튼 동작
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text('다음'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
