import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flts_platform_interface.dart';
import 'models/log_level.dart';
import 'models/lts_config.dart';
import 'models/lts_log.dart';

/// An implementation of [FltsPlatform] that uses method channels.
class MethodChannelFlts extends FltsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flts');

  @override
  Future<bool?> initLts(LTSConfig config) {
    return methodChannel.invokeMethod("initLts", config.toJson());
  }

  @override
  Future report(LTSReport report) {
    return methodChannel.invokeMethod("report", report.toJson());
  }

  @override
  Future reportImmediately(LTSReport report) {
    return methodChannel.invokeMethod("reportImmediately", report.toJson());
  }

  @override
  Future setLocalLogLevel(LTSLogLevel level) {
    return methodChannel.invokeMethod("setLocalLogLevel", level.name);
  }
}
