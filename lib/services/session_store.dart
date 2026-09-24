import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/photo_session.dart';

class SessionStore {
  SessionStore(this._box);

  final Box<PhotoSession> _box;

  List<PhotoSession> get sessions {
    final values = _box.values.toList();
    values.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return values;
  }

  ValueListenable<Box<PhotoSession>> listenable() => _box.listenable();

  Future<void> add(PhotoSession session) => _box.put(session.id, session);

  Future<void> delete(PhotoSession session) async {
    final file = File(session.outputPath);
    if (await file.exists()) await file.delete();
    await _box.delete(session.id);
  }
}
