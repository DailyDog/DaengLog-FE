import 'package:flutter/material.dart';

class PetEditModalShell extends StatefulWidget {
  final Widget child;
  final VoidCallback onClose;
  const PetEditModalShell(
      {super.key, required this.child, required this.onClose});

  @override
  State<PetEditModalShell> createState() => _PetEditModalShellState();
}

class _PetEditModalShellState extends State<PetEditModalShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    try {
      await _controller.reverse();
    } catch (_) {}
    if (mounted) widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: _close,
      child: Container(
        color: Colors.black.withOpacity(0.77),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.35),
            SlideTransition(
              position: _slide,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: screenHeight * 0.65,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _close,
                        child: Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.02),
                          width: screenWidth * 0.1,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Expanded(child: widget.child),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
