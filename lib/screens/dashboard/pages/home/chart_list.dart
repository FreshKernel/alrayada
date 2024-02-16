import 'package:flutter/material.dart';

@immutable
class ChartItem {
  const ChartItem({
    required this.text,
    this.amount = 0,
    this.percentage = 0,
  });
  final double amount;
  final double percentage;
  final String text;
}

class ChartList extends StatelessWidget {
  const ChartList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ChartBar(
        chartItem: ChartItem(text: 'text'),
      ),
    );
  }
}

class ChartBar extends StatelessWidget {
  const ChartBar({required this.chartItem, super.key});
  final ChartItem chartItem;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
