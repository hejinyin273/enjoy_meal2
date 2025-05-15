package com.kinjos.meal.enjoy_meal.utils

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import java.io.File

object ApkTools {
    /**
     * 安装一个apk
     *
     * @param context     上下文
     * @param authorities Android N 授权
     * @param apk         安装包文件
     */
    fun installApk(context: Context, authorities: String?, apk: File?) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.setAction(Intent.ACTION_VIEW)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addCategory(Intent.CATEGORY_DEFAULT)
        val uri: Uri
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            uri = FileProvider.getUriForFile(context, authorities!!, apk!!)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        } else {
            uri = Uri.fromFile(apk)
        }
        intent.setDataAndType(uri, "application/vnd.android.package-archive")
        context.startActivity(intent)
    }

    /**
     * 获取当前app的版本号
     *
     * @param context 上下文
     */
    fun getVersionName(context: Context): String {
        try {
            val packageManager = context.packageManager
            val packageInfo = packageManager.getPackageInfo(context.packageName, 0)
            if (packageInfo != null) {
                return packageInfo.versionName!!
            }
            return "1.0.0"
        } catch (e: Exception) {
            e.printStackTrace()
            return "1.0.0"
        }
    }

    /**
     * 获取app名字
     *
     * @param context 上下文
     */
    fun getAppName(context: Context): String {
        try {
            val packageManager = context.packageManager
            val applicationInfo = packageManager.getApplicationInfo(context.packageName, 0)
            return packageManager.getApplicationLabel(applicationInfo) as String
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }
        return ""
    }

    fun isIntentExisting(context: Context, intent: Intent?): Boolean {
        val packageManager = context.packageManager
        val resolveInfo =
            packageManager.queryIntentActivities(intent!!, PackageManager.MATCH_DEFAULT_ONLY)
        return resolveInfo.size > 0
    }

    fun getAppVersionName(context: Context, packageName: String): String {
        val manager = context.packageManager
        var versionName = ""
        try {
            val packageInfo = manager.getPackageInfo(packageName, PackageManager.GET_CONFIGURATIONS)
            if (packageInfo != null) {
                versionName = packageInfo.versionName!!
            }
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }
        return versionName
    }

}