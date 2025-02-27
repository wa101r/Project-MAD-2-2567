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
                  Expanded(child: _buildChart(questionProvider.history)),
                  const SizedBox(height: 20),
                  Expanded(child: _buildHistoryList(questionProvider.history)),
                ],
              ),
            ),
    );
  }

  Widget _buildChart(List<TestResult> history) {
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
              showTitles: true, // ✅ แสดงเฉพาะตัวเลขด้านซ้าย (แกน Y)
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, // ✅ แสดงตัวเลขด้านล่าง (แกน X)
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
          rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false)), // ❌ ซ่อนแกนขวา
          topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false)), // ❌ ซ่อนด้านบน
        ),
        borderData: FlBorderData(show: true),
      ),
    );
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
            title: Text("คะแนน: ${result.score}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                "วันที่: ${DateFormat('dd/MM/yyyy HH:mm').format(result.date)}"),
          ),
        );
      },
    );
  }
}
