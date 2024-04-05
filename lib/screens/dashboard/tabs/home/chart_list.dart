import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../logic/settings/settings_cubit.dart';

/// A class that hold both the [month] and the [amount] spending for the month
/// will use it to generate the [ChartItem] instance
@immutable
class MonthlyTotal {
  const MonthlyTotal({
    required this.month,
    required this.amount,
  });

  final int month;
  final double amount;
}

/// A class that is used internally by the [ChartList] to pass it to the [ChartItem]
@immutable
class ChartItem {
  const ChartItem({
    required this.text,
    required this.amount,
    required this.percentage,
  });

  /// The value is in dollar, for example 50 which will be $50 in the ui
  final double amount;

  /// Should be between 0...1
  final double percentage;
  final String text;
}

class ChartList extends StatelessWidget {
  const ChartList({
    required this.monthlyTotals,
    super.key,
  });

  final List<MonthlyTotal> monthlyTotals;

  double get totalSpending => monthlyTotals.fold(
        0.0,
        (previousValue, element) => previousValue + element.amount,
      );

  double getSpendingPercentageOfTotal(double amount) {
    if (amount == 0) return 0; // To prevent dividing by zero
    return amount / totalSpending;
  }

  Iterable<ChartItem> getCharts({required SettingsState settingsState}) {
    final now = DateTime.now();
    return List.generate(
      12,
      (index) {
        final date = DateTime(
          now.year,
          now.month - index,
        );
        // Dart handles negative month values by adjusting the year accordingly
        // If you can't understand this logic, use this print statemenet:
        // print(
        //   '${now.month} - $index = ${now.month - index} which is ${date.toString()}',
        // );
        final amount = monthlyTotals
            .firstWhere(
              (monthlyTotal) => monthlyTotal.month == date.month,
              orElse: () => const MonthlyTotal(month: -1, amount: 0.0),
            )
            .amount;
        final text = settingsState.useMonthNumberInChart
            ? date.month.toString()
            : DateFormat.MMMM().format(date).substring(0, 3);
        return ChartItem(
          text: text,
          amount: amount,
          percentage: getSpendingPercentageOfTotal(amount),
        );
      },
    ).reversed;
  }

  Widget getScrollableChart(SettingsState settingsState) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: getCharts(settingsState: settingsState)
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChartBar(item),
              ))
          .toList(),
    );
  }

  Widget getNonScrollableChart(SettingsState settingsState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: getCharts(settingsState: settingsState)
          .map(
            (item) => Expanded(
              child: ChartBar(item),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(12),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.forceUseScrollableChart !=
                current.forceUseScrollableChart ||
            previous.useMonthNumberInChart != current.useMonthNumberInChart,
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (state.forceUseScrollableChart) {
                return getScrollableChart(state);
              }
              if (constraints.maxWidth >= 345) {
                return getNonScrollableChart(state);
              }
              // TODO: See month number in smaller devices
              if (state.useMonthNumberInChart) {
                return getNonScrollableChart(state);
              }
              return getScrollableChart(state);
            },
          );
        },
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
            SizedBox(
              height: constraints.maxHeight * (0.195),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '\$${chart.amount.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.02),
            SizedBox(
              height: constraints.maxHeight * 0.6,
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
            SizedBox(
              height: constraints.maxHeight * 0.025,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.16,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  chart.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
