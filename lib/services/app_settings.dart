import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppSettings extends ChangeNotifier {
  AppSettings(this._box);

  static const _mirrorCameraKey = 'mirror_camera';

  final Box<bool> _box;

  bool get mirrorCamera => _box.get(_mirrorCameraKey, defaultValue: false)!;

  Future<void> setMirrorCamera(bool enabled) async {
    if (enabled == mirrorCamera) return;
    await _box.put(_mirrorCameraKey, enabled);
    notifyListeners();
  }
}
