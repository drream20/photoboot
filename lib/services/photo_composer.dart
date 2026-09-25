import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/booth_layout.dart';
import 'app_settings.dart';

class PhotoComposer {
  Future<File> compose({
    required PhotoBoothLayout layout,
    required List<File> photos,
    required List<bool> mirrorPhotos,
    required DateTime capturedAt,
    required PhotoLook look,
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
        capturedAt.toIso8601String(),
        look.key,
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
  String capturedAt,
  String lookKey,
  Uint8List logoBytes,
) async {
  final width = isStrip ? 1200 : 1800;
  final height = isStrip ? 3600 : 1200;
  const contentScale = .88;
  final footerHeight = height - (height * contentScale).round();
  final look = PhotoLook.fromKey(lookKey);
  final backgroundValue = switch (look) {
    PhotoLook.original => colorValue,
    PhotoLook.vintage => 0xFFE9DCC4,
    PhotoLook.blackAndWhite => 0xFFF4F2EC,
  };
  final footerTextColor = look == PhotoLook.blackAndWhite
      ? img.ColorRgb8(35, 35, 35)
      : img.ColorRgb8(75, 62, 47);
  final output = img.Image(width: width, height: height);
  img.fill(
    output,
    color: img.ColorRgb8(
      (backgroundValue >> 16) & 0xFF,
      (backgroundValue >> 8) & 0xFF,
      backgroundValue & 0xFF,
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
    switch (look) {
      case PhotoLook.original:
        break;
      case PhotoLook.vintage:
        img.sepia(source, amount: .86);
        break;
      case PhotoLook.blackAndWhite:
        img.grayscale(source);
        break;
    }
    final slot = slotValues[index];
    final slotWidth = (slot[2] * width).round();
    final slotHeight = (slot[3] * height * contentScale).round();
    final cropped = _coverCrop(source, slotWidth, slotHeight);
    img.compositeImage(
      output,
      cropped,
      dstX: (slot[0] * width).round(),
      dstY: (slot[1] * height * contentScale).round(),
    );
  }
  final localDate = DateTime.parse(capturedAt).toLocal();
  const monthNames = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];
  final dateLabel =
      '${localDate.day.toString().padLeft(2, '0')} '
      '${monthNames[localDate.month - 1]} ${localDate.year}';
  final font = img.arial48;
  final labelWidth = dateLabel.codeUnits.fold<int>(
    0,
    (width, code) => width + (font.characters[code]?.xAdvance ?? 0),
  );
  img.drawString(
    output,
    dateLabel,
    font: font,
    x: (width - labelWidth) ~/ 2,
    y: height - footerHeight + (footerHeight - 48) ~/ 2,
    color: footerTextColor,
  );
  final logo = img.decodeImage(logoBytes);
  if (logo != null) {
    final logoWidth = width ~/ 16;
    final resized = img.copyResize(logo, width: logoWidth);
    img.compositeImage(
      output,
      resized,
      dstX: width - logoWidth - (width ~/ 36),
      dstY: height - footerHeight + (footerHeight - resized.height) ~/ 2,
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
