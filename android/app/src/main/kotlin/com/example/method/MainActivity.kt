package com.example.method

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    private val Channel = "com.anikuttan/battery"
    private val blueOnOffChannel = "com.anikuttan/bluetooth_On_OFF"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)


//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Channel
        ).setMethodCallHandler { call, result ->
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }

        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            blueOnOffChannel
        ).setMethodCallHandler  { call, result ->
            if (call.method == "getBluetoothStatus") {
                var bluetoothStatus = false
                val bluetoothManager: BluetoothManager =
                    getSystemService(BluetoothManager::class.java)
                val bluetoothAdapter: BluetoothAdapter? = bluetoothManager.getAdapter()
                if (bluetoothAdapter != null) {

                    if (bluetoothAdapter.isEnabled) {
                        bluetoothStatus = true
                        result.success( bluetoothStatus)
                    }else{
                        bluetoothStatus = false
                        result.success(bluetoothStatus)
                    }
                    // Device doesn't support Bluetooth
                } else {
                    result.error("UNAVAILABLE", "Bluetooth not available.", null)
                }
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        batteryLevel = if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(
                null,
                IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            )
            intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(
                BatteryManager.EXTRA_SCALE,
                -1
            )
        }

        return batteryLevel
    }
}