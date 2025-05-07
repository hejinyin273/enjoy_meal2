import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'custom_file_system_io.dart';

/// The DefaultCacheManager that can be easily used directly. The code of
/// this implementation can be used as inspiration for more complex cache
/// managers.
class DefaultCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'meal';

  static final DefaultCacheManager _instance = DefaultCacheManager._();

  factory DefaultCacheManager() {
    return _instance;
  }

  DefaultCacheManager._() : super(Config(key,
    stalePeriod: const Duration(days: 1825), ///5 year
    maxNrOfCacheObjects: 500,
    repo: JsonCacheInfoRepository(databaseName: key),
    fileSystem: CustomFileSystemIo(key),
    fileService: HttpFileService(),
  ));
}