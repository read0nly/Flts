import 'flts_platform_interface.dart';
import 'models/log_level.dart';
import 'models/lts_config.dart';
import 'models/lts_log.dart';

class Flts {
  Future<bool?> initLts(LTSConfig config) {
    return FltsPlatform.instance.initLts(config);
  }

  Future report(LTSReport report) {
    return FltsPlatform.instance.report(report);
  }

  Future reportImmediately(LTSReport report) {
    return FltsPlatform.instance.reportImmediately(report);
  }

  Future setLocalLogLevel(LTSLogLevel level) {
    return FltsPlatform.instance.setLocalLogLevel(level);
  }
}
