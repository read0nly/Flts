class LTSReport {
  List<Map<String, String>> logs;
  Map<String, String> labels;

  LTSReport({required this.logs, this.labels = const {}});

  Map<String, dynamic> toJson() => {
        "logs": logs,
        "labels": labels,
      };
}
