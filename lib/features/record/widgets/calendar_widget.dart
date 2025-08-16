import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 334,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Header with month/year and arrows
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Month and Year
                Row(
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
              child: _buildCalendarGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
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
      
      calendarDays.add(_CalendarDay(
        day: day.toString(),
        isSelected: isSelected,
        isToday: isToday,
        onTap: () {
          setState(() {
            _selectedDate = date;
          });
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
  
  const _CalendarDay({
    required this.day,
    this.isSelected = false,
    this.isToday = false,
    this.isEmpty = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return const SizedBox(width: 44, height: 44);
    }
    
    Color textColor = const Color(0xFF272727);
    double fontSize = 20;
    FontWeight fontWeight = FontWeight.w400;
    
    if (isSelected) {
      textColor = const Color(0xFF007AFF);
      fontSize = 24;
      fontWeight = FontWeight.w500;
    } else if (isToday) {
      textColor = const Color(0xFF007AFF);
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
