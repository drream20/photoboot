package com.example.photoboot

import android.content.ContentValues
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "photoboot/gallery")
            .setMethodCallHandler { call, result ->
                if (call.method == "androidSdk") {
                    result.success(Build.VERSION.SDK_INT)
                    return@setMethodCallHandler
                }
                if (call.method != "saveImage") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val bytes = call.argument<ByteArray>("bytes")
                val name = call.argument<String>("name")
                if (bytes == null || name.isNullOrBlank()) {
                    result.error("invalid_image", "Image data or file name is missing.", null)
                    return@setMethodCallHandler
                }

                try {
                    val resolver = contentResolver
                    val values = ContentValues().apply {
                        put(MediaStore.Images.Media.DISPLAY_NAME, name)
                        put(MediaStore.Images.Media.MIME_TYPE, "image/png")
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/Photo Booth Maker")
                            put(MediaStore.Images.Media.IS_PENDING, 1)
                        }
                    }
                    val collection = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
                    } else {
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI
                    }
                    val uri = resolver.insert(collection, values)
                        ?: throw IOException("Could not create a gallery image.")
                    try {
                        resolver.openOutputStream(uri)?.use { stream -> stream.write(bytes) }
                            ?: throw IOException("Could not open the gallery image.")
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            values.clear()
                            values.put(MediaStore.Images.Media.IS_PENDING, 0)
                            resolver.update(uri, values, null, null)
                        }
                        result.success(uri.toString())
                    } catch (error: Exception) {
                        resolver.delete(uri, null, null)
                        throw error
                    }
                } catch (error: Exception) {
                    result.error("gallery_save_failed", error.message, null)
                }
            }
    }
}
