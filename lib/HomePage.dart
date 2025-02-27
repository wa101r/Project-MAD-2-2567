import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/questionProvider.dart';
import 'package:account/formScreen.dart';
import 'package:account/historyScreen.dart'; // ✅ เพิ่ม import ไฟล์ HistoryScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => QuestionProvider()..initQuestions()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mental Health Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ดูแลสุขภาพจิตของคุณ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history), // ✅ เพิ่มไอคอนประวัติการทดสอบ
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(0, 52, 200, 180)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'ยินดีต้อนรับสู่แบบทดสอบสุขภาพจิต',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'สำรวจสุขภาพจิตของคุณผ่านแบบทดสอบที่ออกแบบมาโดยผู้เชี่ยวชาญ และรับคำแนะนำที่เหมาะสมสำหรับคุณ',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/mental_health.png', // ตรวจสอบให้แน่ใจว่ามีไฟล์ภาพใน assets
                height: 100,
                width: 100, // สามารถตั้งค่าความกว้างตามต้องการ
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.health_and_safety,
                        size: 100, color: Colors.blue),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  debugPrint("Navigating to FormScreen");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FormScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('เริ่มทำแบบทดสอบ'),
              ),
              const SizedBox(height: 10), // ✅ เพิ่มระยะห่าง
              ElevatedButton(
                onPressed: () {
                  debugPrint("Navigating to HistoryScreen");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor:
                      const Color.fromARGB(255, 255, 255, 255), // ✅ สีปุ่ม
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('ดูประวัติการทดสอบ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
