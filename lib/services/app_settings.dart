import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum PhotoLook {
  original('original', 'Original'),
  vintage('vintage', 'Vintage'),
  blackAndWhite('black_and_white', 'Black & white');

  const PhotoLook(this.key, this.label);

  final String key;
  final String label;

  static PhotoLook fromKey(Object? key) => PhotoLook.values.firstWhere(
    (look) => look.key == key,
    orElse: () => PhotoLook.original,
  );
}

class AppSettings extends ChangeNotifier {
  AppSettings(this._box);

  static const _mirrorCameraKey = 'mirror_camera';
  static const _photoLookKey = 'photo_look';

  final Box<dynamic> _box;

  bool get mirrorCamera =>
      _box.get(_mirrorCameraKey, defaultValue: false) as bool;

  PhotoLook get photoLook => PhotoLook.fromKey(_box.get(_photoLookKey));

  Future<void> setMirrorCamera(bool enabled) async {
    if (enabled == mirrorCamera) return;
    await _box.put(_mirrorCameraKey, enabled);
    notifyListeners();
  }

  Future<void> setPhotoLook(PhotoLook look) async {
    if (look == photoLook) return;
    await _box.put(_photoLookKey, look.key);
    notifyListeners();
  }
}
