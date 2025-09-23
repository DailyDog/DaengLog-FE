import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/mypage/get/my_page_summary_api.dart';
import 'package:daenglog_fe/api/mypage/models/my_page_summary.dart';
import 'package:daenglog_fe/api/mypage/get/pet_simple_list_api.dart';
import 'package:daenglog_fe/api/mypage/models/pet_simple_item.dart';
import 'package:daenglog_fe/api/mypage/post/pet_set_default_api.dart';

class MyPageProvider extends ChangeNotifier {
  MyPageSummary? summary;
  List<PetSimpleItem> simplePets = [];
  bool loadingSummary = false;
  bool loadingSimple = false;
  String? error;

  Future<void> fetchSummary() async {
    loadingSummary = true;
    error = null;
    notifyListeners();
    try {
      summary = await MyPageSummaryApi().getSummary();
    } catch (e) {
      error = '$e';
    } finally {
      loadingSummary = false;
      notifyListeners();
    }
  }

  Future<void> fetchSimplePets() async {
    loadingSimple = true;
    notifyListeners();
    try {
      simplePets = await PetSimpleListApi().getMySimpleList();
    } finally {
      loadingSimple = false;
      notifyListeners();
    }
  }

  Future<void> setDefaultByIndex(int index) async {
    if (index < 0 || index >= simplePets.length) return;
    final id = simplePets[index].id;
    await PetSetDefaultApi().setDefault(id);
    await fetchSummary();
  }
}


