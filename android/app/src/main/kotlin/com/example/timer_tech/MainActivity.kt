package com.example.timer_tech

import java.time.LocalDate

import android.os.Bundle
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {

    private val METHOD_CHANNEL = "timertech.dev/timer"


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            val date = call.argument<String>("date") ?: "2020-02-02"
            val min = call.argument<Int>("min") ?: 15
            when (call.method) {
                "startTimer" -> startTimer(date, min)
                "stopTimer" -> stopTimer()
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startTimer(date: String, min: Int) {
        Intent(this, TimerService::class.java).also { intent ->
            intent.putExtra("date", date)
            intent.putExtra("sec", min*60)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(intent)
            } else {
                startService(intent)
            }
        }

    }

    private fun stopTimer() {
        Intent(this, TimerService::class.java).also { intent ->
            stopService(intent)
        }
    }

}
