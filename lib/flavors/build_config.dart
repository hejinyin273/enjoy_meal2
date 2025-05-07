

import 'env_config.dart';
import 'env_flavor.dart';

class BuildConfig {
  late final EnvFlavor envFlavor;
  late final EnvConfig config;
  bool _lock = false;

  static final BuildConfig instance = BuildConfig._internal();

  BuildConfig._internal();

  factory BuildConfig.instantiate({
    required EnvFlavor envFlavor,
    required EnvConfig envConfig,
  }) {
    if (instance._lock) return instance;

    instance.envFlavor = envFlavor;
    instance.config = envConfig;
    instance._lock = true;

    return instance;
  }
}