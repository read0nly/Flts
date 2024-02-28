import 'dart:io';

import 'package:flts/models/log_level.dart';
import 'package:flts/models/lts_config.dart';
import 'package:flts/models/lts_log.dart';
import 'package:flutter/material.dart';
import 'package:flts/flts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _fltsPlugin = Flts();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  LTSConfig config = LTSConfig(
                    region: "cn-north-4",
                    projectId: "06a466459100105c2feac01ded5cb953",
                    groupId: "66a427eb-b4d9-47db-a815-11fe426593b3",
                    streamId: "9882be8e-c92c-49c9-88a3-6e95caafced5",
                    accessKey: "IJE5X178OWCLCVKHUN7D",
                    secretKey: "ZZIcw0bxkZwusuNhNUPRKYGu6VEEX9MJuy3TZHex",
                  );
                  _fltsPlugin.initLts(config);
                  _fltsPlugin.setLocalLogLevel(LTSLogLevel.DEBUG);
                },
                child: Text("init"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _fltsPlugin.reportImmediately(LTSReport(logs: [
                    {"测试日志key": "测试日志的value${Platform.operatingSystem}"},
                    {"测试日志key2": "测试日志的value2${Platform.operatingSystem}"},
                  ], labels: {
                    "label_key": "label_value"
                  }));
                },
                child: Text("report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
