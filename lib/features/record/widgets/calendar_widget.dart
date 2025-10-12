import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/api/diary/get/diary_monthly_calendar_api.dart';
import 'package:daenglog_fe/api/diary/models/diary_monthly_calendar_model.dart';
import 'package:daenglog_fe/api/diary/get/diary_by_pet_api.dart';
import 'package:daenglog_fe/features/record/screens/diary_photo_cards_screen.dart';
import 'package:daenglog_fe/features/record/providers/record_provider.dart';
import 'package:flutter/cupertino.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  Future<DiaryMonthlyCalendarModel>? _monthlyFuture;
  final Map<String, DiaryMonthlyCalendarModel> _monthlyCache = {};
  int? _petId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePetId();
  }

  void _updatePetId() {
    final recordProvider = context.read<RecordProvider>();
    final newPetId = recordProvider.selectedPet?.id;

    if (newPetId != _petId) {
      _petId = newPetId;
      _monthlyCache.clear(); // 캐시 초기화
      _loadMonthly();
    }
  }

  String _ymKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  void _loadMonthly() {
    if (_petId == null) return;
    final key = _ymKey(_focusedDate);
    if (_monthlyCache.containsKey(key)) {
      setState(() {
        _monthlyFuture = Future.value(_monthlyCache[key]);
      });
      return;
    }
    setState(() {
      _monthlyFuture = DiaryMonthlyCalendarApi()
          .getDiaryMonthlyCalendar(
        petId: _petId,
        year: _focusedDate.year,
        month: _focusedDate.month,
      )
          .then((model) {
        _monthlyCache[key] = model;
        return model;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordProvider>(
      builder: (context, recordProvider, child) {
        // 반려동물이 변경되었을 때 petId 업데이트
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updatePetId();
        });

        return Container(
          height: 334,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // 상단 여백 추가
              const SizedBox(height: 16),

              // Header with month/year and arrows
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Month and Year
                    GestureDetector(
                      onTap: () async {
                        final picked =
                            await _showYearMonthPicker(context, _focusedDate);
                        if (picked != null &&
                            (picked.year != _focusedDate.year ||
                                picked.month != _focusedDate.month)) {
                          setState(() {
                            _focusedDate = DateTime(picked.year, picked.month);
                          });
                          _loadMonthly();
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            '${_focusedDate.year}.${_focusedDate.month.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF272727),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF95C6FF),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    // Navigation arrows
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _focusedDate = DateTime(
                                _focusedDate.year,
                                _focusedDate.month - 1,
                              );
                            });
                            _loadMonthly();
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Color(0xFF95C6FF),
                            size: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _focusedDate = DateTime(
                                _focusedDate.year,
                                _focusedDate.month + 1,
                              );
                            });
                            _loadMonthly();
                          },
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF95C6FF),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 월/년도와 요일 사이 간격 추가
              const SizedBox(height: 12),

              // Weekday headers
              Container(
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _WeekdayHeader(text: '월', isBold: true),
                    _WeekdayHeader(text: '화'),
                    _WeekdayHeader(text: '수'),
                    _WeekdayHeader(text: '목'),
                    _WeekdayHeader(text: '금'),
                    _WeekdayHeader(text: '토'),
                    _WeekdayHeader(text: '일'),
                  ],
                ),
              ),

              // Calendar grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder<DiaryMonthlyCalendarModel>(
                    future: _monthlyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('달력 데이터를 불러오지 못했습니다.'));
                      }
                      final model = snapshot.data;
                      final dayMap = <int, DiaryMonthlyCalendarDay>{};
                      if (model != null) {
                        for (final d in model.calendarDays) {
                          final parts = d.date.split('-');
                          if (parts.length == 3) {
                            final day = int.tryParse(parts[2]);
                            if (day != null) {
                              dayMap[day] = d;
                            }
                          }
                        }
                      }
                      return _buildCalendarGrid(dayMap);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendarGrid(Map<int, DiaryMonthlyCalendarDay> dayMap) {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> calendarDays = [];

    // Add empty cells for days before the first day of the month
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(const _CalendarDay(day: '', isEmpty: true));
    }

    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedDate.year, _focusedDate.month, day);
      final isSelected = date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;
      final isToday = date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;
      final dayData = dayMap[day];
      final thumbUrl = dayData?.thumbnailImageUrl;

      calendarDays.add(_CalendarDay(
        day: day.toString(),
        isSelected: isSelected,
        isToday: isToday,
        thumbnailUrl: thumbUrl,
        onTap: () {
          _onDayTapped(date, dayData);
        },
      ));
    }

    // Group days into weeks
    List<Widget> weeks = [];
    for (int i = 0; i < calendarDays.length; i += 7) {
      final weekDays = calendarDays.skip(i).take(7).toList();
      // Pad with empty cells if week is incomplete
      while (weekDays.length < 7) {
        weekDays.add(const _CalendarDay(day: '', isEmpty: true));
      }

      weeks.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDays,
        ),
      );
    }

    return Column(
      children: weeks,
    );
  }

  Future<void> _onDayTapped(
      DateTime date, DiaryMonthlyCalendarDay? dayData) async {
    setState(() {
      _selectedDate = date;
    });
    if (dayData == null || _petId == null) return;
    try {
      final diaries = await DiaryByPetApi().getDiaryByPet(petId: _petId!);
      final String y = date.year.toString().padLeft(4, '0');
      final String m = date.month.toString().padLeft(2, '0');
      final String d = date.day.toString().padLeft(2, '0');
      final String target = '$y-$m-$d';
      final filtered = diaries.where((e) => e.date == target).toList();
      if (!mounted) return;
      if (filtered.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DiaryPhotoCardsScreen(diaries: filtered),
          ),
        );
      }
    } catch (e) {
      // ignore for now or show snackbar
    }
  }

  Future<DateTime?> _showYearMonthPicker(
      BuildContext context, DateTime initial) async {
    final int initialYear = initial.year;
    final int initialMonth = initial.month;
    final int startYear = initialYear - 50;
    final int endYear = initialYear + 50;

    int selectedYear = initialYear;
    int selectedMonth = initialMonth;

    return showModalBottomSheet<DateTime>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 260,
          child: Column(
            children: [
              Container(
                height: 44,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(ctx)
                        .pop(DateTime(selectedYear, selectedMonth));
                  },
                  child: const Text('완료'),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: initialYear - startYear),
                        itemExtent: 36,
                        onSelectedItemChanged: (index) {
                          selectedYear = startYear + index;
                        },
                        children: [
                          for (int y = startYear; y <= endYear; y++)
                            Center(child: Text('$y년')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: initialMonth - 1),
                        itemExtent: 36,
                        onSelectedItemChanged: (index) {
                          selectedMonth = index + 1;
                        },
                        children: [
                          for (int m = 1; m <= 12; m++)
                            Center(
                                child:
                                    Text('${m.toString().padLeft(2, '0')}월')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String text;
  final bool isBold;

  const _WeekdayHeader({
    required this.text,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 13,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          color: const Color(0xFF3C3C43).withOpacity(0.3),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final String day;
  final bool isSelected;
  final bool isToday;
  final bool isEmpty;
  final VoidCallback? onTap;
  final String? thumbnailUrl;

  const _CalendarDay({
    required this.day,
    this.isSelected = false,
    this.isToday = false,
    this.isEmpty = false,
    this.onTap,
    this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return const SizedBox(width: 44, height: 44);
    }

    Color textColor = const Color(0xFF272727);
    Color backgroundColor = Colors.transparent;
    double fontSize = 16;
    FontWeight fontWeight = FontWeight.w400;

    // 선택된 날짜와 오늘 날짜를 구분
    if (isSelected) {
      textColor = Colors.white;
      backgroundColor = const Color(0xFFFFB78C); // 주황색 계열 배경
      fontSize = 18;
      fontWeight = FontWeight.w600;
    } else if (isToday) {
      textColor = const Color(0xFFFFB78C);
      backgroundColor = const Color(0xFFFFB78C).withOpacity(0.1); // 연한 주황색 배경
      fontSize = 16;
      fontWeight = FontWeight.w500;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: isToday && !isSelected
              ? Border.all(color: const Color(0xFFFFB78C), width: 2)
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
              ClipOval(
                child: Image.network(
                  thumbnailUrl!,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                ),
              ),
            if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0x73FF6205),
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              day,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
                    ? 14
                    : fontSize,
                fontWeight: fontWeight,
                color: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
                    ? Colors.white
                    : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
