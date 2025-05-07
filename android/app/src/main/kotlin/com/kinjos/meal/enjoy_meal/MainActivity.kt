package com.kinjos.meal.enjoy_meal

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.content.FileProvider
import com.kinjos.meal.enjoy_meal.utils.ApkTools
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStreamReader

class MainActivity: FlutterActivity() {
    companion object{
        private const val TAG : String = "EnjoyMeal"
        private const val helperChannel:String = "com.kinjos.meal.enjoy_meal/helper"

    }
    private var methodChannel: MethodChannel? = null

    private fun init(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor, helperChannel)
        methodChannel!!.setMethodCallHandler {
                call, result ->
            if(call.method == "installApk"){
                val filePath = call.arguments as String
                installApk(filePath)
                result.success(true)
            } else if(call.method == "getVersionName"){
                result.success(ApkTools.getVersionName(context));
            } else if(call.method == "execRuntimeCommand"){
                val command = call.arguments as String
                result.success(execRuntimeCommand(command))
            } else if(call.method == "handleHostInstall"){
                val filePath = call.arguments as String
                result.success(handleAppInstall(filePath))
            } else if(call.method == "checkAndInstallHelper"){
                checkAndInstallHelper(result)
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        init(flutterEngine)
    }

    private fun installApk(filePath: String){
        val file = File(filePath)
        if(file.exists()){
            ApkTools.installApk(context, context.packageName + ".fileProvider", file)
        }
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    }

    private fun execRuntimeCommand(command: String): Boolean {
        var bufferedReader: BufferedReader? = null
        try {
            Log.i(TAG, "execRuntimeCommand() $command")
            val process = Runtime.getRuntime().exec(command)
            bufferedReader = BufferedReader(InputStreamReader(process.errorStream))
            val errMsg = bufferedReader.readLine()
            if (errMsg != null) {
                Log.e(TAG, "errResult-->$errMsg")
                return false
            }
            return true
        } catch (e: Exception) {
            Log.e(TAG, "execRuntimeCommand() err $e")
        } finally {
            if (bufferedReader != null) {
                try {
                    bufferedReader.close()
                } catch (e: IOException) {
                    Log.e(TAG, "execRuntimeCommand() err $e")
                }
            }
        }
        return false
    }

    private fun handleAppInstall(apkPath: String): Boolean {
        val intent = Intent("manager.helper.SESSION_API_PACKAGE_INSTALLED")
        val componentName = ComponentName(
            "com.kinjos.meal.helper",
            "com.kinjos.meal.helper.MainActivity"
        )
        intent.setComponent(componentName)
        if (!ApkTools.isIntentExisting(this, intent)) {
            Log.e(TAG, "Something wrong? manager app not exist!");
            return false
        } else {
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

            val uri: Uri
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                uri = FileProvider.getUriForFile(context, context.packageName + ".fileProvider", File(apkPath))
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            } else {
                uri = Uri.fromFile(File(apkPath))
            }

            //intent.putExtra("ApkPath", hostApkPath)
            intent.setData(uri)
            intent.putExtra("PluginName", "fileId")
            intent.putExtra("DoneToPackageName", packageName)
            intent.putExtra("DoneToClassName", "com.kinjos.meal.enjoy_meal.MainActivity")
            startActivity(intent)
            return true
        }
    }

    private fun checkAndInstallHelper(result: MethodChannel.Result){
        try {
            Log.i(TAG, "checkAndInstallHelper()")
            val helperVersion = ApkTools.getAppVersionName(this, "com.kinjos.meal.helper")
            Log.i(TAG, "checkAndInstallHelper() helperVersion=$helperVersion")
            if ("1.0" != helperVersion) {
                val assetFileName = "MealHelper_v1.0";
                val filePathName = context.externalCacheDir!!.absolutePath + File.separator + assetFileName;
                Log.i(TAG, "checkAndInstallHelper() assetFileName=$assetFileName, filePathName=$filePathName")
                copyAssetFileTo(assetFileName, filePathName)
                result.success(execRuntimeCommand("pm install $filePathName"));
            } else {
                result.success(true)
            }
        }catch (e: IOException) {
            Log.e(TAG, "checkAndInstallHelper() err=$e")
            result.success(false)
        }
    }

    @Throws(IOException::class)
    fun copyAssetFileTo(filename: String, filePathName: String,): Boolean {
        val of = File(filePathName)
        if (of.exists()) {
            of.delete()
        }

        val `is` = context.assets.open(filename)
        val buffer = ByteArray(`is`.available())
        `is`.read(buffer)
        of.createNewFile()
        val os = FileOutputStream(of)
        os.write(buffer)
        os.close()
        `is`.close()
        return true;
    }

}

