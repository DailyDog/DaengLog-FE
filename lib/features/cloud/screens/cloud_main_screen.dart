import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/my_membership/free_plan_widget.dart';
import '../widgets/my_membership/daeng_cloud_plus_widget.dart';
import '../widgets/my_membership/family_members_widget.dart';
import '../widgets/my_membership/storage_management_buttons_widget.dart';
import '../providers/cloud_screen_provider.dart';
import 'subscription_plan_screen.dart';

class CloudMainScreen extends StatefulWidget {
  const CloudMainScreen({super.key});

  @override
  State<CloudMainScreen> createState() => _CloudMainScreenState();
}

class _CloudMainScreenState extends State<CloudMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CloudScreenProvider>();
    _tabController = TabController(length: 2, vsync: this, initialIndex: provider.currentMainTabIndex);
    
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        provider.setMainTabIndex(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF5F01),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '용량 관리',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Pretendard',
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.05),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.black, // 활성 탭 밑줄
              indicatorWeight: 3,
              labelColor: Colors.black,      // 활성 탭 글자색
              unselectedLabelColor: Colors.grey[600], // 비활성 탭 글자색
              labelStyle: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: '마이 멤버십'),
                Tab(text: '요금제'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CloudMainContent(),
          SubscriptionPlanScreen(),
        ],
      ),
    );
  }
}

// 마이 멤버십 내용을 담는 위젯
class CloudMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.025),
          // 무료플랜 위젯
          FreePlanWidget(),
          SizedBox(height: screenHeight * 0.025),
          // 용량 관리 버튼들
          StorageManagementButtonsWidget(),
          SizedBox(height: screenHeight * 0.025),
          // 댕클라우드+ 위젯
          DaengCloudPlusWidget(),
          SizedBox(height: screenHeight * 0.025),
          // 우리가족 구성원 위젯
          FamilyMembersWidget(),
          SizedBox(height: screenHeight * 0.12), // 하단 네비게이션 바 공간
        ],
      ),
    );
  }
}

// 재사용 가능한 탭 텍스트 위젯
class _TabText extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  final double screenWidth;
  final Color activeColor;
  final Color inactiveColor;
  final FontWeight fontWeightActive;
  final FontWeight fontWeightInactive;

  const _TabText({
    required this.title,
    required this.isActive,
    required this.onTap,
    required this.screenWidth,
    required this.activeColor,
    required this.inactiveColor,
    required this.fontWeightActive,
    required this.fontWeightInactive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: isActive ? fontWeightActive : fontWeightInactive,
          color: isActive ? activeColor : inactiveColor,
          decoration: isActive ? TextDecoration.underline : TextDecoration.none,
          decorationColor: activeColor,
          decorationThickness: 2,
        ),
      ),
    );
  }
}