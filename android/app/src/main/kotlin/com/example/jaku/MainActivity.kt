package com.example.jaku

import android.content.Intent
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "jaku.channel/ringtone"
    private var pendingResult: MethodChannel.Result? = null
    private lateinit var ringtonePickerLauncher: ActivityResultLauncher<Intent>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Mendaftarkan peluncur untuk ActivityResult (untuk Picker Nada Dering)
        ringtonePickerLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            if (result.resultCode == RESULT_OK) {
                val data: Intent? = result.data
                val uri: Uri? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI, Uri::class.java)
                } else {
                    @Suppress("DEPRECATION")
                    data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
                }
                pendingResult?.success(uri?.toString())
            } else {
                pendingResult?.success(null)
            }
            pendingResult = null
        }

        // Konfigurasi agar aplikasi bisa dibangunkan saat layar terkunci (Lock Screen)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // PERHATIAN: 
        // Baris `GeneratedPluginRegistrant.registerWith(flutterEngine)` DIHAPUS
        // karena Flutter versi baru (>= 3.0) sudah otomatis mendaftarkan plugin.
        // Menambahkan baris tersebut akan menyebabkan Warning 'already registered'
        // dan masalah saat di-compile ke mode Release.
        super.configureFlutterEngine(flutterEngine)

        // Mendaftarkan MethodChannel untuk komunikasi Dart <-> Kotlin
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openRingtonePicker" -> {
                    pendingResult = result
                    val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER).apply { 
                        putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_ALARM)
                        putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, true)
                        putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, true)
                    }
                    ringtonePickerLauncher.launch(intent)
                }

                "getDefaultAlarmUri" -> {
                    val defaultUri: Uri? = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                    result.success(defaultUri?.toString())
                }
                
                "getRingtoneTitle" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString != null) {
                        try {
                            val uri = Uri.parse(uriString)
                            val ringtone = RingtoneManager.getRingtone(this, uri)
                            val title = ringtone?.getTitle(this) ?: "Unknown Alarm"
                            result.success(title)
                        } catch (e: Exception) {
                            result.success("Unknown Alarm")
                        }
                    } else {
                        result.success("Unknown Alarm")
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}