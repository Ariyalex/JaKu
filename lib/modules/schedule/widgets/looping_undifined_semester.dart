import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoopingUndifinedSemester extends HookWidget {
  const LoopingUndifinedSemester({super.key});

  @override
  Widget build(BuildContext context) {
    final showJaku = useState<bool>(true);

    useEffect(() {
      Timer? currentTimer;

      void startTimer() {
        final duration = showJaku.value
            ? const Duration(seconds: 20)
            : const Duration(seconds: 5);

        currentTimer = Timer(duration, () {
          showJaku.value = !showJaku.value;

          startTimer();
        });
      }

      startTimer();

      return () {
        currentTimer?.cancel();
      };
    }, []);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: AlignmentGeometry.centerLeft,
          children: [...previousChildren, ?currentChild],
        );
      },
      child: showJaku.value
          ? Text("JaKu", key: ValueKey('text_jaku'), textAlign: TextAlign.start)
          : Text(
              'semester default',
              key: ValueKey('text_undifined'),
              textAlign: TextAlign.start,
            ),
    );
  }
}
