import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/subscribe_plan/cloud_plan_widget.dart';
import '../providers/cloud_screen_provider.dart';
import '../widgets/subscribe_plan/cloud_plus_diary_plan_widget.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // provider를 통해 현재 선택된 요금제 탭 인덱스 업데이트
      context.read<CloudScreenProvider>().setPlanTabIndex(_tabController.index);
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

    return Container(
      width: double.infinity,
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Consumer<CloudScreenProvider>(
        builder: (context, cloudProvider, child) {
          // provider의 상태와 TabController 동기화
          if (_tabController.index != cloudProvider.currentPlanTabIndex) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _tabController.animateTo(cloudProvider.currentPlanTabIndex);
            });
          }

          return Column(
            children: [
              // 탭 바
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.black,
                    indicatorWeight: 3,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey[600],
                    labelStyle: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(text: '댕클라우드'),
                      Tab(text: '댕클라우드+일기'),
                    ],
                ),
              ),
              
              // 탭 내용
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                        CloudPlanWidget(
                        title: '댕클라우드',
                        description: '댕클라우드 요금제입니다.',
                        price: '10000',
                        features: ['10000', '10000', '10000'],
                        buttonText: '구매하기',
                        ),
                        
                        CloudPlanWidget(
                        title: '댕클라우드',
                        description: '댕클라우드 요금제입니다.',
                        price: '10000',
                        features: ['10000', '10000', '10000'],
                        buttonText: '구매하기',
                        ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          CloudPlusDiaryPlanWidget(
                            title: '댕클라우드+일기',
                            description: '댕클라우드+일기 요금제입니다.',
                            price: '10000',
                              features: ['10000', '10000', '10000'],
                              buttonText: '구매하기',
                          ),
                          CloudPlusDiaryPlanWidget(
                            title: '댕클라우드+일기',
                            description: '댕클라우드+일기 요금제입니다.',
                            price: '10000',
                              features: ['10000', '10000', '10000'],
                              buttonText: '구매하기',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
