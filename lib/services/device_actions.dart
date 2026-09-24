import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class DeviceActions {
  static const _galleryChannel = MethodChannel('photoboot/gallery');

  Future<void> saveToGallery(File file) async {
    final sdk = await _galleryChannel.invokeMethod<int>('androidSdk');
    if (sdk != null && sdk <= 28) {
      final permission = await Permission.storage.request();
      if (!permission.isGranted) {
        throw StateError(
          'Storage permission is needed to save on this Android version.',
        );
      }
    }
    await _galleryChannel.invokeMethod<void>('saveImage', {
      'bytes': await file.readAsBytes(),
      'name': file.uri.pathSegments.last,
    });
  }

  Future<void> share(File file) => SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path)],
      text: 'Made with Photo Booth Maker ✨',
      title: 'My photo booth photo',
    ),
  );

  Future<void> printPhoto(File file) async {
    final image = pw.MemoryImage(await file.readAsBytes());
    final document = pw.Document();
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
      ),
    );
    await Printing.layoutPdf(
      onLayout: (_) => document.save(),
      name: 'Photo Booth photo',
    );
  }
}
