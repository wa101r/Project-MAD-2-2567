import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:account/provider/questionProvider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuestionProvider>(context, listen: false).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    var questionProvider = Provider.of<QuestionProvider>(context);
    int currentMaxScore = questionProvider.questions.length * 5;
    int maxHistoryScore = questionProvider.history.isNotEmpty
        ? questionProvider.history
            .map((e) => e.score)
            .reduce((a, b) => a > b ? a : b)
        : currentMaxScore;

    int maxScore =
        (maxHistoryScore > currentMaxScore) ? maxHistoryScore : currentMaxScore;

    return Scaffold(
      appBar: AppBar(title: const Text("ประวัติการทดสอบ")),
      body: questionProvider.history.isEmpty
          ? const Center(
              child: Text(
                "ยังไม่มีข้อมูลการทดสอบ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "แนวโน้มสุขภาพจิตของคุณ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                      child: _buildChart(questionProvider.history, maxScore)),
                  const SizedBox(height: 20),
                  Expanded(child: _buildHistoryList(questionProvider.history)),
                ],
              ),
            ),
    );
  }

  Widget _buildChart(List<TestResult> history, int maxScore) {
    if (history.isEmpty) {
      return const Center(child: Text("ไม่มีข้อมูลสำหรับแสดงกราฟ"));
    }

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: history
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.score.toDouble()))
                .toList(),
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 100,
              getTitlesWidget: (value, meta) {
                return _getMentalHealthLabel(value.toInt(), maxScore);
              },
              interval: maxScore / 4,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < history.length) {
                  return Text(
                    DateFormat("dd/MM").format(history[index].date),
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 30,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        gridData: FlGridData(show: true),
        minY: 0,
        maxY: maxScore.toDouble(),
      ),
    );
  }

  Widget _getMentalHealthLabel(int score, int maxScore) {
    int range = maxScore ~/ 5;

    if (score >= range * 4) {
      return const Text("🚨 แย่สุด",
          style: TextStyle(fontSize: 12, color: Colors.red));
    }
    if (score >= range * 3) {
      return const Text("🔴 ค่อนข้างแย่",
          style: TextStyle(fontSize: 12, color: Colors.orange));
    }
    if (score >= range * 2) {
      return const Text("🟠 ปานกลาง",
          style: TextStyle(fontSize: 12, color: Colors.amber));
    }
    if (score >= range * 1) {
      return const Text("🟡 ดี",
          style: TextStyle(fontSize: 12, color: Colors.green));
    }
    return const Text("🟢 ดีมาก",
        style: TextStyle(fontSize: 12, color: Colors.blue));
  }

  Widget _buildHistoryList(List<TestResult> history) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        var result = history[index];

        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.history, color: Colors.blue),
            title: Text(
              "ผลลัพธ์: ${result.result.split("\n\n")[0]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "วันที่: ${DateFormat('dd/MM/yyyy HH:mm').format(result.date)}",
            ),
          ),
        );
      },
    );
  }
}
