import 'package:flts/models/log_level.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flts_method_channel.dart';
import 'models/lts_config.dart';
import 'models/lts_log.dart';

abstract class FltsPlatform extends PlatformInterface {
  /// Constructs a FltsPlatform.
  FltsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FltsPlatform _instance = MethodChannelFlts();

  /// The default instance of [FltsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlts].
  static FltsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FltsPlatform] when
  /// they register themselves.
  static set instance(FltsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> initLts(LTSConfig config) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future report(LTSReport report) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future reportImmediately(LTSReport report) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future setLocalLogLevel(LTSLogLevel level) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
