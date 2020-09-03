package com.example.timer_tech


import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import androidx.core.app.NotificationCompat

class TimerService : Service() {
    private val CHANNEL_ID = "timer_tech"

    override fun onCreate() {
        super.onCreate()

        var builder = NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("title")
                .setContentText("text")
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForeground(101, builder.build())
        }
    }


    override fun onBind(intent: Intent): IBinder? {
        // We don't provide binding, so return null
        return null
    }

}
