package com.example.my_native_ringtone

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MyNativeRingtonePlugin */
class MyNativeRingtonePlugin :
    FlutterPlugin,
    MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context


    companion object {
        var mediaPlayer: MediaPlayer? = null
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "my_native_ringtone")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "playRingtone" -> {
                val uriString = call.argument<String>("uri")
                playRingtone(uriString)
                result.success(true)
                
            }
            "stopRingtone" -> {
                stopRingtone()
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun playRingtone(uriString: String?) {
        try {
            stopRingtone()

            val uri: Uri = if (uriString.isNullOrEmpty()) {
                
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            } else {
                Uri.parse(uriString)
            }
            
            mediaPlayer = MediaPlayer().apply { 
                setDataSource(context, uri)

                val audioAttributes = AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_ALARM).setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION).build()
                setAudioAttributes(audioAttributes)

                isLooping = true
                setOnErrorListener { _, what, extra ->
                    Log.e("NativeRingtone", "🐛 [NativeMediaPlayer] Error memutar audio: what=$what, extra=$extra")
                    true // Return true menandakan error telah di-handle
                }

                prepare()
                start()
             }
             Log.d("NativeRingtone", "🐛 [NativeMediaPlayer] Alarm berhasil diputar!")
        } catch (e: Exception) {
            Log.e("NativeRingtone", "🐛 [NativeRingtone] Error memutar ringtone: ${e.message}")
        }
    }

    private fun stopRingtone() {
        if (mediaPlayer != null && mediaPlayer!!.isPlaying) {
            mediaPlayer?.stop()
            mediaPlayer?.release()
            mediaPlayer = null
            Log.d("NativeRingtone", "🐛 [NativeMediaPlayer] Alarm berhasil dihentikan.")
        } else {
            Log.d("NativeRingtone", "🐛 [NativeRingtone] Mengabaikan stop: Tidak ada ringtone yang sedang menyala.")
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        stopRingtone()
    }
}
