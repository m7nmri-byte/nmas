import 'dart:async';
import 'package:flutter/material.dart';

import '../models/session.dart';

/// نص يعرض الوقت الحالي مباشرة، ويتحدث كل ثانية.
class LiveClockText extends StatefulWidget {
  final TextStyle? style;
  const LiveClockText({super.key, this.style});

  @override
  State<LiveClockText> createState() => _LiveClockTextState();
}

class _LiveClockTextState extends State<LiveClockText> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final period = now.hour < 12 ? 'ص' : 'م';
    var h12 = now.hour % 12;
    if (h12 == 0) h12 = 12;
    final text =
        '${twoDigits(h12)}:${twoDigits(now.minute)}:${twoDigits(now.second)} $period';
    return Text(text, style: widget.style, textDirection: TextDirection.ltr);
  }
}
