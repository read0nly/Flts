package com.cc.flts

import android.app.Application
import androidx.annotation.NonNull
import com.cloud.LTSSDK
import com.cloud.UserConfig
import com.cloud.util.log.LogLevel

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.collections.HashMap as HashMap1

/** FltsPlugin */
class FltsPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    var mContext: android.app.Application? = null
    var lts: LTSSDK? = null
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flts")
        mContext = flutterPluginBinding.applicationContext as android.app.Application;
        channel.setMethodCallHandler(this)
    }


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initLts" -> {
                initLts(call, result)
            }

            "setLocalLogLevel" -> {
                setLocalLogLevel(call, result)
            }

            "report" -> {
                report(call, result)
            }

            "reportImmediately" -> {
                reportImmediately(call, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun initLts(@NonNull call: MethodCall, @NonNull result: Result) {
        var arguments = call.arguments as Map<String, String>;
        val userConfig = UserConfig.Builder().setRegion(arguments["region"] ?: "")  // 云日志服务的区域
            .setProjectId(arguments["projectId"] ?: "")  // 华为云账号的项目ID
            .setGroupId(arguments["groupId"] ?: "")  // LTS的日志组ID
            .setStreamId(arguments["streamId"] ?: "")  // LTS的日志流ID
            .setAccessKey(arguments["accessKey"] ?: "")  // 华为云访问密钥
            .setSecretKey(arguments["secretKey"] ?: "")  // 华为云秘密访问秘钥
            .build()
        var lts = LTSSDK(mContext!!, userConfig)
        if (lts.isInitialized) {
            print("LTSSDK isInitialized:true");
        }
        this.lts = lts
    }

    private fun setLocalLogLevel(@NonNull call: MethodCall, @NonNull result: Result) {
        var levelName = call.arguments as? String ?: return
        var level: kotlin.Int = LogLevel.OFF
        when (levelName) {
            "DEBUG" -> {
                level = LogLevel.DEBUG
            }

            "ERROR" -> {
                level = LogLevel.ERROR
            }

            "INFO" -> {
                level = LogLevel.INFO
            }

            "OFF" -> {
                level = LogLevel.OFF
            }

            "WARNING" -> {
                level = LogLevel.WARNING
            }
        }
        LTSSDK.setLogLevel(level)
        result.success(true)
    }


    private fun report(call: MethodCall, result: Result) {
        val arguments = call.arguments as? Map<String, Any> ?: return
        val logs = arguments["logs"] as? ArrayList<HashMap1<String, Any>> ?: return
        val labels = arguments["labels"] as? HashMap1<String, Any> ?: return

        lts?.report(logs.toTypedArray(), labels)
        result.success(true)
    }

    private fun reportImmediately(call: MethodCall, result: Result) {
        val arguments = call.arguments as? Map<String, Any> ?: return
        val logs = arguments["logs"] as? ArrayList<HashMap1<String, Any>> ?: return
        val labels = arguments["labels"] as? HashMap1<String, Any> ?: return
        lts?.reportImmediately(logs.toTypedArray(), labels)
        result.success(true)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }


}
