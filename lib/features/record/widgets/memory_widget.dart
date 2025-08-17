import 'package:flutter/material.dart';

class MemoryWidget extends StatelessWidget {
  const MemoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Memory title with icon
          Row(
            children: [
              Text(
                '추억',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF272727),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz,
                color: Color(0xFF8C8B8B),
                size: 20,
              ),
            ],
          ),
          
          const SizedBox(height: 18),
          
          // Memory content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Memory photo
              Container(
                width: 71,
                height: 97,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/images/family/send_back.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Memory text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Memory title
                    Text(
                      '🐾 조심스러운 간식 시간 🦴',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF272727),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Memory description
                    Text(
                      '오늘도 내 자리에서 푹신푹신한 담요 위에 누웠다. 세상에서 제일 편한 이 자리, 누구도 침범할 수 없다. 근데…',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8C8B8B),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
