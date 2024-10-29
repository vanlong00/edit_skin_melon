import 'package:injectable/injectable.dart';

import '../core/utils/helpers/version_data_helper.dart';

@lazySingleton
class PreInitData {
  final VersionDataHelper _versionDataHelper;

  PreInitData(this._versionDataHelper);

  Future<void> initialize() async {
    Future.wait([
      _checkVersionData(),
    ]);
  }

  Future<void> _checkVersionData() async {
    await _versionDataHelper.checkDataServer();
  }
}
