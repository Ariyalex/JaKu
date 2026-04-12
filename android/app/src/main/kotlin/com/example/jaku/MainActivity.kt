package com.example.jaku

import android.content.Intent
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val CHANNEL = "jaku.channel/ringtone"
    private var pendingResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {call, result ->
            when (call.method) {
                "openRingtonePicker" -> {
                    pendingResult = result
                    val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER).apply { 
                        putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_ALARM)
                        putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, true)
                        putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, true)
                    }
                    startActivityForResult(intent, 999)
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        
        // Menangkap hasil dari Ringtone Picker UI bawaan Android
        if (requestCode == 999) {
            if (resultCode == RESULT_OK) {
                // Pengecekan versi OS untuk menghindari Deprecation Warning
                val uri: Uri? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    // Untuk Android 13 ke atas (Aman tipe data)
                    data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI, Uri::class.java)
                } else {
                    // Untuk Android 12 ke bawah
                    @Suppress("DEPRECATION")
                    data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
                }
                
                pendingResult?.success(uri?.toString())
            } else {
                pendingResult?.success(null) // User membatalkan pilihan
            }
            pendingResult = null // Bersihkan memori
        }
    }
}
