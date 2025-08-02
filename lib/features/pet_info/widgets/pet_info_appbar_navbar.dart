import 'package:flutter/material.dart';


// 반려동물 정보 입력 화면 위젯
Widget buildPetInfoScreen({
  required int? currentStep, // 추가된 부분
  required String subject,
  required String title,
  required String titleSub,
  required String subtitle,
  required VoidCallback onPrevious,  // 이전 버튼 클릭 시 동작
  required VoidCallback? onNext,  // 다음 버튼 클릭 시 동작
  Widget? child, // 추가된 부분
}) {
  bool isActive = false;
  return Scaffold(
    
    body: Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Image.asset(
              'assets/images/information/info_background.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              // 상단 타이틀 바
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: List.generate(4, (index) {
                        const labels = ['댕', '댕', '일', '기'];
                        bool isActive = false;
                        if(currentStep != null) {
                          isActive = index <= currentStep;
                        }
                        return TextSpan(
                          text: labels[index],
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 20,
                            color: isActive ? Color(0xFFFF5F01) : Color(0xFFADADAD),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 0.5),
              SizedBox(
                width: 75,
                child: Divider(
                  color: currentStep != null ? Color(0xFFFF5F01) : Color(0xFFADADAD),
                  thickness: 1,
                  height: 1,
                ),
              ),
              
              // 메인 제목
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: subject, style: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w700, fontSize: 20, color: Color(0xFF272727))),
                    TextSpan(text: title, style: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w700, fontSize: 20, color: Color(0xFFFF5F01))),
                    TextSpan(text: titleSub, style: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w700, fontSize: 20, color: Color(0xFF272727))),
                  ],
                ),
              ),
              // 서브타이틀
              const SizedBox(height: 5),
              Text(subtitle, style: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF8C8B8B))),
              const SizedBox(height: 40),
              if (child != null) child,
            ],
          ),
        ),
      ],
    ),
  
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onPrevious, // 이전 버튼 클릭 시 동작
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFF5F01)),
                  foregroundColor: const Color(0xFFFF5F01),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('이전', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: onNext, // 다음 버튼 클릭 시 동작
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5F01),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('다음',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
