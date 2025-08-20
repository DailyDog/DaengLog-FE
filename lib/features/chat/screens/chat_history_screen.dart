import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/services/chat_history_storage.dart';
import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';
import 'package:daenglog_fe/features/chat/widgets/chat_gpt_photo_card.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<DiaryGptResponse> _diaries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDiaries();
  }

  Future<void> _loadDiaries() async {
    try {
      final diaries = await ChatHistoryStorage.getRecentDiaries();
      setState(() {
        _diaries = diaries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshDiaries() async {
    setState(() {
      _isLoading = true;
    });
    await _loadDiaries();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.06; // 화면 너비의 6%
    final titleFontSize = screenWidth * 0.045; // 화면 너비의 4.5%
    final dateBadgeTop = screenHeight * 0.08; // 화면 높이의 8%
    final emptyStateTop = screenHeight * 0.15; // 화면 높이의 15%
    final dateBadgeWidth = screenWidth * 0.3; // 화면 너비의 30%
    final dateBadgeHeight = screenHeight * 0.035; // 화면 높이의 3.5%
    final fontSize = screenWidth * 0.035; // 화면 너비의 3.5%
    // 현재 날짜를 "YY.MM.DD(요일)" 형식으로 포맷
    final now = DateTime.now();
    final formattedDate = "${now.year % 100}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}(${['월','화','수','목','금','토','일'][now.weekday-1]})";


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5F01),
        title: Text(
          '히스토리', 
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh, 
              color: Colors.white,
              size: iconSize,
            ),
            onPressed: _refreshDiaries,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDiaries,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _diaries.isEmpty
                ? _buildEmptyState()
                : _buildDiaryList(formattedDate),
      ),
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;
        
        // 화면 크기에 따른 동적 값 계산
        final dateBadgeTop = screenHeight * 0.08; // 화면 높이의 8%
        final emptyStateTop = screenHeight * 0.15; // 화면 높이의 15%
        final dateBadgeWidth = screenWidth * 0.3; // 화면 너비의 30%
        final dateBadgeHeight = screenHeight * 0.035; // 화면 높이의 3.5%
        final fontSize = screenWidth * 0.035; // 화면 너비의 3.5%
        
        return Stack(
          children: [
            // Date Badge
            Positioned(
              top: dateBadgeTop,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: dateBadgeWidth,
                  height: dateBadgeHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEDB),
                    borderRadius: BorderRadius.circular(dateBadgeHeight * 0.74), // height의 74%
                  ),
                  child: Center(
                    child: Text(
                      '25.05.03(금)',
                      style: TextStyle(
                        color: const Color(0xFFFF5F01),
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Empty State Content
            Positioned(
              top: emptyStateTop,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '히스토리가 비어있네요',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: fontSize,
                        color: const Color(0xFF5C5C5C),
                        height: 1.54,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005), // 화면 높이의 0.5%
                    Text(
                      '일기를 생성해 보세요',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: fontSize,
                        color: const Color(0xFF5C5C5C),
                        height: 1.54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDiaryList(String formattedDate) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        
        // 화면 크기에 따른 동적 값 계산
        final horizontalPadding = screenWidth * 0.05; // 화면 너비의 5%
        final verticalPadding = screenHeight * 0.025; // 화면 높이의 2.5%
        final itemSpacing = screenHeight * 0.025; // 화면 높이의 2.5%
        
        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          itemCount: _diaries.length,
          itemBuilder: (context, index) {
            final diary = _diaries[index];
            return Padding(
              padding: EdgeInsets.only(bottom: itemSpacing),
              child: ChatGptPhotoCard(
                formattedDate: formattedDate,
                gptResponse: diary,
              ),
            );
          },
        );
      },
    );
  }
}
