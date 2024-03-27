import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

@immutable
class ChartItem {
  const ChartItem({
    required this.text,
    this.amount = 0,
    this.percentage = 0,
  });

  /// The value is in dollar
  final double amount;

  /// Should be between 0...1
  final double percentage;
  final String text;
}

class ChartList extends StatelessWidget {
  const ChartList({super.key});

  List<ChartItem> get _charts {
    return [
      const ChartItem(text: 'text', amount: 50, percentage: 0.5),
      const ChartItem(text: 'text', amount: 5000),
      const ChartItem(text: 'text'),
      const ChartItem(text: 'text'),
      const ChartItem(text: 'text'),
      const ChartItem(text: 'text'),
      // 6
      const ChartItem(text: 'text', amount: 50, percentage: 0.5),
      const ChartItem(text: 'text', amount: 5000),
      const ChartItem(text: 'text'),
      const ChartItem(text: 'text'),
      const ChartItem(text: 'text'),
      const ChartItem(text: 'text'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _charts.map((e) => Expanded(child: ChartBar(e))).toList(),
      ),
    );
  }
}

class ChartBar extends StatelessWidget {
  const ChartBar(this.chart, {super.key});
  final ChartItem chart;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Text(
              '\$${chart.amount.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 100,
              width: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: chart.percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCupertino(context)
                            ? CupertinoTheme.of(context).primaryColor
                            : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              chart.text,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
            )
          ],
        );
      },
    );
  }
}
