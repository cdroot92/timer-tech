package com.example.timer_tech

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import java.util.*
import kotlin.concurrent.timer
import kotlin.math.floor

import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class TimerService : Service() {
    private val CHANNEL_ID = "timer_tech"
    private val NOTI_ID = 101

    var sec = 0;
    var date = "";
    var timerInstance: Timer? = null;
    var notiManager: NotificationManager? = null;
    var notiBuilder: NotificationCompat.Builder? = null;

    override fun onCreate() {
        super.onCreate()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        date = intent!!.getStringExtra("date")
        sec = intent!!.getIntExtra("sec", 0)

        startTimer()

        val mainIntent = Intent(this, MainActivity::class.java)
        val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, mainIntent, 0)

        createNotificationChannel()
        notiBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Timer Tech")
                .setContentText("date: $date, time: ${getTimerText(sec)}")
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setSmallIcon(R.drawable.ic_stat_name)
                .setContentIntent(pendingIntent)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setAutoCancel(false)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForeground(NOTI_ID, notiBuilder?.build())
        }

        return super.onStartCommand(intent, flags, startId)
    }

    fun getTimerText(sec: Int): String {
        val s = floor(sec%60.0).toInt()
        val min = floor(sec/60.0).toInt()
        val m = floor( min%60.0).toInt()
        val h = floor(min/60.0).toInt()


        return "$h:$m:$s"
    }

    fun startTimer() {
        timerInstance = timer(period = 1000) {
            if(sec > 0) {
                sec -= 1
                notiBuilder?.setContentText("date: $date, time: ${getTimerText(sec)}")
                notiManager?.notify(NOTI_ID, notiBuilder?.build())
            } else {
                finishTimer()
            }
        }
    }

    fun pauseTimer() {
        timerInstance?.cancel()
    }

    fun stopTimer() {
        timerInstance?.cancel()
        sec = 0
    }

    fun finishTimer() {
        val mainIntent = Intent(applicationContext, MainActivity::class.java).also { intent ->
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, mainIntent, 0)
        pendingIntent.send()
        stopSelf()
    }


    override fun onDestroy() {
        stopTimer()
        // vibration for notification
        super.onDestroy()
    }


    override fun onBind(intent: Intent): IBinder? {
        // We don't provide binding, so return null
        return null
    }

    private fun createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "timer_tech"
            val descriptionText = "timer_tech description"
            val importance = NotificationManager.IMPORTANCE_LOW
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            // Register the channel with the system
            notiManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notiManager?.createNotificationChannel(channel)
        }
    }

}
