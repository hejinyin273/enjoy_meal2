package com.kinjos.meal.enjoy_meal.utils

import android.content.Context
import android.content.Intent
import android.content.IntentSender
import android.content.pm.PackageInfo
import android.content.pm.PackageInstaller
import android.content.pm.PackageInstaller.SessionParams
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import java.io.File
import java.io.FileInputStream
import java.io.IOException

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

    fun installApkSession(
        context: Context,
        apkFilePath: String,
        statusReceiver: IntentSender?
    ): Boolean {
        var session: PackageInstaller.Session? = null
        try {
            val file = File(apkFilePath)
            if (!file.exists()) return false
            val packageInstaller = context.packageManager.packageInstaller
            val params = SessionParams(
                SessionParams.MODE_FULL_INSTALL
            )
            params.setSize(file.length())
            params.setInstallLocation(PackageInfo.INSTALL_LOCATION_PREFER_EXTERNAL)

            val sessionId = packageInstaller.createSession(params)
            session = packageInstaller.openSession(sessionId)

            addApkToInstallSession(apkFilePath, session, file.length())

            // Commit the session (this will start the installation workflow).
            session.commit(statusReceiver!!)
            return true
        } catch (e: IOException) {
            throw RuntimeException("Couldn't install package", e)
        } catch (e: RuntimeException) {
            session?.abandon()
            return false
        } finally {
            session?.close()
        }
    }

    @Throws(IOException::class)
    private fun addApkToInstallSession(
        assetName: String,
        session: PackageInstaller.Session,
        lengthBytes: Long
    ) {
        // It's recommended to pass the file size to openWrite(). Otherwise installation may fail
        // if the disk is almost full.
        session.openWrite("package", 0, lengthBytes).use { packageInSession ->
            FileInputStream(assetName).use { `is` ->
                val buffer = ByteArray(16384)
                var n: Int
                while ((`is`.read(buffer).also { n = it }) >= 0) {
                    packageInSession.write(buffer, 0, n)
                }
                session.fsync(packageInSession)
            }
        }
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