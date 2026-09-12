package com.qll.pet_health

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.provider.MediaStore
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import kotlin.concurrent.thread
import kotlin.math.max

class MainActivity : FlutterFragmentActivity() {
    private var pendingImages: MethodChannel.Result? = null
    private var pendingVideo: MethodChannel.Result? = null

    private val imagePicker = registerForActivityResult(
        ActivityResultContracts.PickMultipleVisualMedia(150)
    ) { uris ->
        val result = pendingImages
        pendingImages = null
        if (result == null) return@registerForActivityResult
        thread {
            val values = uris.mapNotNull { uri ->
                persist(uri)
                metadata(uri, "image")
            }
            runOnUiThread { result.success(values) }
        }
    }

    private val videoPicker = registerForActivityResult(
        ActivityResultContracts.PickVisualMedia()
    ) { uri ->
        val result = pendingVideo
        pendingVideo = null
        if (result == null) return@registerForActivityResult
        if (uri == null) {
            result.success(null)
            return@registerForActivityResult
        }
        thread {
            persist(uri)
            val value = metadata(uri, "video")
            runOnUiThread { result.success(value) }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "pet_health/album_assets"
        ).setMethodCallHandler(::handleAlbumAssetCall)
    }

    private fun handleAlbumAssetCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "pickImages" -> {
                if (pendingImages != null) {
                    result.error("picker_busy", "相册选择器正在使用", null)
                    return
                }
                pendingImages = result
                imagePicker.launch(
                    PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly)
                )
            }
            "pickVideo" -> {
                if (pendingVideo != null) {
                    result.error("picker_busy", "相册选择器正在使用", null)
                    return
                }
                pendingVideo = result
                videoPicker.launch(
                    PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.VideoOnly)
                )
            }
            "requestThumbnail", "requestPreview" -> {
                val reference = call.argument<String>("ref")
                val size = call.argument<Int>("size") ?: 512
                if (reference == null) {
                    result.error("bad_arguments", "缺少媒体引用", null)
                    return
                }
                thread {
                    val bytes = thumbnail(Uri.parse(reference), size)
                    runOnUiThread { result.success(bytes) }
                }
            }
            "openAsset" -> {
                val reference = call.argument<String>("ref")
                result.success(reference?.takeIf { available(Uri.parse(it)) })
            }
            "checkAvailability" -> {
                val reference = call.argument<String>("ref")
                result.success(reference != null && available(Uri.parse(reference)))
            }
            "releaseReference" -> {
                val reference = call.argument<String>("ref")
                if (reference != null) {
                    try {
                        contentResolver.releasePersistableUriPermission(
                            Uri.parse(reference),
                            Intent.FLAG_GRANT_READ_URI_PERMISSION
                        )
                    } catch (_: Exception) {
                        // The URI may already have expired or may be shared elsewhere.
                    }
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun persist(uri: Uri) {
        try {
            contentResolver.takePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION
            )
        } catch (_: Exception) {
            // Some backported pickers already retain the grant for the app.
        }
    }

    private fun metadata(uri: Uri, kind: String): Map<String, Any?>? {
        if (!available(uri)) return null
        var width: Int? = null
        var height: Int? = null
        var durationMs: Long? = null
        var capturedAt: Long? = null

        if (kind == "image") {
            try {
                contentResolver.openInputStream(uri)?.use { stream ->
                    val options = BitmapFactory.Options().apply { inJustDecodeBounds = true }
                    BitmapFactory.decodeStream(stream, null, options)
                    width = options.outWidth.takeIf { it > 0 }
                    height = options.outHeight.takeIf { it > 0 }
                }
            } catch (_: Exception) {
            }
        } else {
            try {
                val retriever = MediaMetadataRetriever()
                retriever.setDataSource(this, uri)
                width = retriever.extractMetadata(
                    MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH
                )?.toIntOrNull()
                height = retriever.extractMetadata(
                    MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT
                )?.toIntOrNull()
                durationMs = retriever.extractMetadata(
                    MediaMetadataRetriever.METADATA_KEY_DURATION
                )?.toLongOrNull()
                retriever.release()
            } catch (_: Exception) {
            }
        }

        try {
            contentResolver.query(
                uri,
                arrayOf(MediaStore.MediaColumns.DATE_TAKEN),
                null,
                null,
                null
            )?.use { cursor ->
                if (cursor.moveToFirst()) {
                    capturedAt = cursor.getLong(0).takeIf { it > 0 }
                }
            }
        } catch (_: Exception) {
        }

        return mapOf(
            "ref" to uri.toString(),
            "kind" to kind,
            "width" to width,
            "height" to height,
            "durationMs" to durationMs,
            "capturedAt" to capturedAt
        )
    }

    private fun available(uri: Uri): Boolean {
        return try {
            contentResolver.openAssetFileDescriptor(uri, "r")?.use { true } ?: false
        } catch (_: Exception) {
            false
        }
    }

    private fun thumbnail(uri: Uri, targetSize: Int): ByteArray? {
        val mime = contentResolver.getType(uri).orEmpty()
        val bitmap = if (mime.startsWith("video/")) {
            try {
                val retriever = MediaMetadataRetriever()
                retriever.setDataSource(this, uri)
                val frame = retriever.getFrameAtTime(
                    0,
                    MediaMetadataRetriever.OPTION_CLOSEST_SYNC
                )
                retriever.release()
                frame
            } catch (_: Exception) {
                null
            }
        } else {
            decodeSampled(uri, targetSize)
        } ?: return null

        val scaled = scaleWithin(bitmap, targetSize)
        if (scaled !== bitmap) bitmap.recycle()
        return ByteArrayOutputStream().use { stream ->
            scaled.compress(Bitmap.CompressFormat.JPEG, 84, stream)
            scaled.recycle()
            stream.toByteArray()
        }
    }

    private fun decodeSampled(uri: Uri, targetSize: Int): Bitmap? {
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        contentResolver.openInputStream(uri)?.use {
            BitmapFactory.decodeStream(it, null, bounds)
        }
        var sample = 1
        while (max(bounds.outWidth, bounds.outHeight) / sample > targetSize * 2) {
            sample *= 2
        }
        val options = BitmapFactory.Options().apply { inSampleSize = sample }
        return contentResolver.openInputStream(uri)?.use {
            BitmapFactory.decodeStream(it, null, options)
        }
    }

    private fun scaleWithin(bitmap: Bitmap, targetSize: Int): Bitmap {
        val longest = max(bitmap.width, bitmap.height)
        if (longest <= targetSize) return bitmap
        val ratio = targetSize.toDouble() / longest
        return Bitmap.createScaledBitmap(
            bitmap,
            (bitmap.width * ratio).toInt().coerceAtLeast(1),
            (bitmap.height * ratio).toInt().coerceAtLeast(1),
            true
        )
    }
}
