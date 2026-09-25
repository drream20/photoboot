import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/booth_layout.dart';

class PhotoComposer {
  Future<File> compose({
    required PhotoBoothLayout layout,
    required List<File> photos,
    required List<bool> mirrorPhotos,
  }) async {
    final logoData = await rootBundle.load('lib/logo/photoboot-logo.png');
    final logoBytes = logoData.buffer.asUint8List(
      logoData.offsetInBytes,
      logoData.lengthInBytes,
    );
    final isStrip = layout.isStrip;
    final colorValue = layout.colorValue;
    final slots = layout.slots
        .map((slot) => [slot.x, slot.y, slot.width, slot.height])
        .toList();
    final photoPaths = photos.map((photo) => photo.path).toList();
    final outputBytes = await Isolate.run(
      () => _composeInBackground(
        isStrip,
        colorValue,
        slots,
        photoPaths,
        mirrorPhotos,
        logoBytes,
      ),
    );
    final directory = await getApplicationDocumentsDirectory();
    final photosDirectory = Directory(p.join(directory.path, 'photo_booth'));
    await photosDirectory.create(recursive: true);
    final now = DateTime.now();
    final file = File(
      p.join(
        photosDirectory.path,
        'photoboot_${now.millisecondsSinceEpoch}.png',
      ),
    );
    await file.writeAsBytes(outputBytes, flush: true);
    return file;
  }
}

Future<Uint8List> _composeInBackground(
  bool isStrip,
  int colorValue,
  List<List<double>> slotValues,
  List<String> photoPaths,
  List<bool> mirrorPhotos,
  Uint8List logoBytes,
) async {
  final width = isStrip ? 1200 : 1800;
  final height = isStrip ? 3600 : 1200;
  final output = img.Image(width: width, height: height);
  img.fill(
    output,
    color: img.ColorRgb8(
      (colorValue >> 16) & 0xFF,
      (colorValue >> 8) & 0xFF,
      colorValue & 0xFF,
    ),
  );
  for (var index = 0; index < slotValues.length; index++) {
    final decoded = img.decodeImage(
      await File(photoPaths[index]).readAsBytes(),
    );
    if (decoded == null) {
      throw StateError('We could not read photo ${index + 1}.');
    }
    final source = img.bakeOrientation(decoded);
    if (mirrorPhotos[index]) img.flipHorizontal(source);
    final slot = slotValues[index];
    final slotWidth = (slot[2] * width).round();
    final slotHeight = (slot[3] * height).round();
    final cropped = _coverCrop(source, slotWidth, slotHeight);
    img.compositeImage(
      output,
      cropped,
      dstX: (slot[0] * width).round(),
      dstY: (slot[1] * height).round(),
    );
  }
  final logo = img.decodeImage(logoBytes);
  if (logo != null) {
    final logoWidth = width ~/ 11;
    final resized = img.copyResize(logo, width: logoWidth);
    img.compositeImage(
      output,
      resized,
      dstX: width - logoWidth - (width ~/ 30),
      dstY: height - resized.height - (height ~/ 30),
    );
  }
  return Uint8List.fromList(img.encodePng(output, level: 6));
}

img.Image _coverCrop(img.Image source, int targetWidth, int targetHeight) {
  final sourceRatio = source.width / source.height;
  final targetRatio = targetWidth / targetHeight;
  late int cropWidth;
  late int cropHeight;
  if (sourceRatio > targetRatio) {
    cropHeight = source.height;
    cropWidth = (cropHeight * targetRatio).round();
  } else {
    cropWidth = source.width;
    cropHeight = (cropWidth / targetRatio).round();
  }
  final crop = img.copyCrop(
    source,
    x: (source.width - cropWidth) ~/ 2,
    y: (source.height - cropHeight) ~/ 2,
    width: cropWidth,
    height: cropHeight,
  );
  return img.copyResize(crop, width: targetWidth, height: targetHeight);
}
