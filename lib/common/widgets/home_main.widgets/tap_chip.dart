import 'package:flutter/material.dart';

class TabChip extends StatelessWidget {
  final String label;
  final bool selected;

  const TabChip({required this.label, required this.selected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? Colors.orange : Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? Colors.orange : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
