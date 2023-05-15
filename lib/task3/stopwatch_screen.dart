import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final stopwatch = Stopwatch();
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    if (stopwatch.isRunning) {
      _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
        setState(() {});
      });
    } else {
      _timer?.cancel();
      _timer = null;
    }
    return Column(
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
              child: Text(
                stopwatch.elapsedMilliseconds.toString(),
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: IconButton.filledTonal(
                    onPressed: () {
                      setState(stopwatch.reset);
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: IconButton.filledTonal(
                    onPressed: () {
                      setState(() {
                        if (stopwatch.isRunning) {
                          stopwatch.stop();
                        } else {
                          stopwatch.start();
                        }
                      });
                    },
                    icon: (stopwatch.isRunning)
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.play_arrow),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    stopwatch.stop();
    super.dispose();
  }
}