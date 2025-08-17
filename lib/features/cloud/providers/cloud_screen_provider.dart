import 'package:flutter/material.dart';

class CloudScreenProvider extends ChangeNotifier {
  // 현재 선택된 메인 탭 (0: 마이 멤버십, 1: 요금제)
  int _currentMainTabIndex = 0;
  
  // 요금제 화면에서 현재 선택된 요금제 탭 (0: 댕클라우드, 1: 댕클라우드+일기)
  int _currentPlanTabIndex = 0;

  // Getters
  int get currentMainTabIndex => _currentMainTabIndex;
  int get currentPlanTabIndex => _currentPlanTabIndex;

  // 메인 탭 변경 메서드
  void setMainTabIndex(int index) {
    _currentMainTabIndex = index;
    notifyListeners();
  }

  // 요금제 탭 변경 메서드
  void setPlanTabIndex(int index) {
    _currentPlanTabIndex = index;
    notifyListeners();
  }

  // 마이 멤버십 탭으로 이동
  void showMyMembership() {
    _currentMainTabIndex = 0;
    notifyListeners();
  }

  // 요금제 탭으로 이동
  void showSubscriptionPlan() {
    _currentMainTabIndex = 1;
    notifyListeners();
  }

  // 요금제 탭에서 댕클라우드 선택
  void selectCloudPlan() {
    _currentPlanTabIndex = 0;
    notifyListeners();
  }

  // 요금제 탭에서 댕클라우드+일기 선택
  void selectCloudPlusDiaryPlan() {
    _currentPlanTabIndex = 1;
    notifyListeners();
  }
}