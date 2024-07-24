import 'package:bet_manager_app/core/theme/colors.dart';
import 'package:bet_manager_app/core/utils/validator.dart';
import 'package:bet_manager_app/models/transaction.dart';
import 'package:bet_manager_app/models/week_day_expansion.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeekTransactionChart extends StatefulWidget {
  final List<WeekDayExpansion> weekDays;

  const WeekTransactionChart({
    super.key,
    required this.weekDays,
  });

  @override
  State<WeekTransactionChart> createState() => _WeekTransactionChartState();
}

class _WeekTransactionChartState extends State<WeekTransactionChart> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    rawBarGroups = _buildChartGroups();
    showingBarGroups = List.of(rawBarGroups);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      rawBarGroups = _buildChartGroups();
      showingBarGroups = List.of(rawBarGroups);
    });
    
    return BarChart(
      BarChartData(
        maxY: 1000,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: ((group) => Colors.grey),
            getTooltipItem: (a, b, c, d) => null,
          ),
          touchCallback: _touchCallback,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _buildBottomTitles,
              reservedSize: 50,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: _buildLeftTitles,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: showingBarGroups,
        gridData: const FlGridData(show: false),
      ),
    );
  }

  // double _getPercentage(double total) {
  //   double weekTotal = widget.recentTransactions.fold(0.0, (previousValue, transaction) => previousValue + transaction.amount);
  //   return weekTotal == 0 ? 0 : (total / weekTotal) * 100;
  // }

  void _touchCallback(FlTouchEvent event, response) {
      if (response == null || response.spot == null) {
        setState(() {
          touchedGroupIndex = -1;
          showingBarGroups = List.of(rawBarGroups);
        });
        return;
      }
      touchedGroupIndex = response.spot!.touchedBarGroupIndex;
      setState(() {
        if (!event.isInterestedForInteractions) {
          touchedGroupIndex = -1;
          showingBarGroups = List.of(rawBarGroups);
          return;
        }
        showingBarGroups = List.of(rawBarGroups);
        if (touchedGroupIndex != -1) {
          var sum = 0.0;
          for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
            sum += rod.toY;
          }
          final avg = sum / showingBarGroups[touchedGroupIndex].barRods.length;

          showingBarGroups[touchedGroupIndex] = showingBarGroups[touchedGroupIndex].copyWith(
            barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
              return rod.copyWith(toY: avg, color: contentColorOrange);
            }).toList(),
          );
        }
      });
    }

  BarChartGroupData _buildDayValues({required int dayPosition, required double earned, required double spent}) {
    return BarChartGroupData(
      barsSpace: 4,
      x: dayPosition,
      barRods: [
        BarChartRodData(
          toY: earned > 1000 ? 1000 : earned,
          color: incomeColor,
          width: 7,
        ),
        BarChartRodData(
          toY: spent > 1000 ? 1000 : spent,
          color: primaryColor,
          width: 7,
        ),
      ],
    );
  }

  Widget _buildLeftTitles(double value, TitleMeta meta) {
    String text;

    switch (value) {
      case 100:
        text = '100';
        break;
      case 500:
        text = '500';
        break;
      case 1000:
        text = '1k+';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Tu', 'Wd', 'Th', 'Fr', 'Sa', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  List<BarChartGroupData> _buildChartGroups() {
    return widget.weekDays.map((day) {
      double earned = 0.0;
      double spent = 0.0;

      for (Transaction transaction in day.transactions) {
        if (Validator.verifyDate(transaction.date, compareTo: day.date)) {
          transaction.type == TransactionType.income
            ? earned += transaction.amount
            : spent += transaction.amount;
        }
      }

      return _buildDayValues(dayPosition: day.date.weekday - 1, earned: earned, spent: spent);
    }).toList();
  }
}
