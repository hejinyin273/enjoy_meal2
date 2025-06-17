package com.kinjos.meal.enjoy_meal

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageInstaller
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.content.FileProvider
import com.gainscha.sdk.demo.ui.PrinterConnectActivity
import com.gainscha.sdk.demo.ui.PrinterMainActivity
import com.gainscha.sdk.demo.util.Constants
import com.gainscha.sdk.demo.util.MenuUtils
import com.gainscha.sdk2.ConnectType
import com.gainscha.sdk2.ConnectionListener
import com.gainscha.sdk2.Printer
import com.gainscha.sdk2.PrinterFinder
import com.gainscha.sdk2.PrinterFinder.SearchPrinterResultListener
import com.gainscha.sdk2.command.EscCommand
import com.gainscha.sdk2.model.BluetoothPrinterDevice
import com.gainscha.sdk2.model.Instruction
import com.gainscha.sdk2.model.SerialPortPrinterDevice
import com.gainscha.sdk2.model.UsbAccessoryPrinterDevice
import com.gainscha.sdk2.model.UsbPrinterDevice
import com.gainscha.sdk2.model.WifiPrinterDevice
import com.kinjos.meal.enjoy_meal.model.OrderDetailResp
import com.kinjos.meal.enjoy_meal.utils.ApkTools
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.io.BufferedReader
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStreamReader
import com.google.gson.Gson


class MainActivity: FlutterActivity(), SearchPrinterResultListener,ConnectionListener{
    companion object{
        private const val TAG : String = "EnjoyMeal"
        private const val HELPER_CHANNEL:String = "com.kinjos.meal.enjoy_meal/helper"
        private const val EVENT_MSG_CHANNEL : String = "com.kinjos.meal.enjoy_meal/eventMsg"
        private const val PACKAGE_INSTALLED_ACTION: String = "install.SESSION_API_PACKAGE_INSTALLED"

        private var sink : EventChannel.EventSink? = null
    }

    private var methodChannel: MethodChannel? = null

    private fun init(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor, HELPER_CHANNEL)
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
                checkAndInstallHelper()
            } else if(call.method == "startPrinterMainActivity"){
                startActivity(Intent(this, PrinterMainActivity::class.java))
            } else if(call.method == "startSearchPrinterActivity"){
                startSearchPrinterActivity()
            } else if (call.method == "isPrinterConnected") {
                result.success(isPrinterConnected())
            } else if (call.method == "startSearchPrinters") {
                val connectType = call.argument<String?>("connectType")
                val uid = call.argument<String?>("uid")
                if (connectType != null && uid != null) {
                    lastPrinterConnType = ConnectType.valueOf(connectType!!)
                    lastPrinterUid = uid
                }
                startSearchPrinters()
            } else if (call.method == "stopSearchPrinters") {
                stopSearchPrinters()
            } else if (call.method == "isOnPrinterSearching") {
                result.success(isOnPrinterSearching)
            } else if (call.method == "checkPrinterStatus") {
                checkPrinterStatus(result)
            } else if (call.method == "printEscDot") {
                val printContent = call.arguments as String
                result.success(printEscDot(printContent))
            } else if (call.method == "startWifiPrinterConnect") {
                val ip = call.argument<String?>("ip")
                val port = call.argument<Int?>("port")
                if (ip != null && port != null) {
                    startWifiPrinterConnect(ip, port)
                }
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_MSG_CHANNEL).setStreamHandler(stateHandler)
    }

    private val stateHandler: EventChannel.StreamHandler = object : EventChannel.StreamHandler{
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            sink = events
        }

        override fun onCancel(arguments: Any?) {
            sink = null
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        init(flutterEngine)
        //Add printer connection listener
        Printer.addConnectionListener(this)
        if (Printer.getConnectedPrinters().isNotEmpty()) {
            printer = Printer.getConnectedPrinters()[0]
        }
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
        registerBroadCast()
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterBroadCast()
        //Remove printer connected listener
        Printer.removeConnectionListener(this)
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
        Log.i(TAG, "handleAppInstall() apkPath=$apkPath");
        if (!ApkTools.isIntentExisting(this, intent)) {
            Log.e(TAG, "Something wrong? helper app not exist!");
            return false
        } else {
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

            val uri: Uri
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                uri = FileProvider.getUriForFile(context, context.packageName + ".fileProvider", File(apkPath))
                Log.i(TAG, "uri path=${uri.path}");
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            } else {
                uri = Uri.fromFile(File(apkPath))
            }

            //intent.putExtra("ApkPath", hostApkPath)
            intent.setData(uri)
            intent.putExtra("PluginName", "fileId")
            intent.putExtra("DoneToPackageName", packageName)
            intent.putExtra("DoneToClassName", "com.kinjos.meal.enjoy_meal.MainActivity")
            Log.i(TAG, "handleAppInstall() start helper.MainActivity");
            startActivity(intent)
            return true
        }
    }

    private fun checkAndInstallHelper(){
        try {
            Log.i(TAG, "checkAndInstallHelper()")
            val helperVersion = ApkTools.getAppVersionName(this, "com.kinjos.meal.helper")
            Log.i(TAG, "checkAndInstallHelper() helperVersion=$helperVersion")
            if ("1.0" != helperVersion) {
                val assetFileName = "MealHelper_v1.0";
                val filePathName = context.externalCacheDir!!.absolutePath + File.separator + assetFileName;
                Log.i(TAG, "checkAndInstallHelper() assetFileName=$assetFileName, filePathName=$filePathName")
                copyAssetFileTo(assetFileName, filePathName)
                handleHelperApkInstall(filePathName)
            } else {
                sink?.success("HelperInstalled")
            }
        }catch (e: IOException) {
            Log.e(TAG, "checkAndInstallHelper() err=$e")
            sink?.success("HelperInstallFailed")
        }
    }

    @Throws(IOException::class)
    fun copyAssetFileTo(filename: String, filePathName: String): Boolean {
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

    private var careBroadcastReceiver: CareBroadcastReceiver? = null

    private fun registerBroadCast() {
        val intentFilter = IntentFilter()
        intentFilter.addAction(PACKAGE_INSTALLED_ACTION)
        careBroadcastReceiver = CareBroadcastReceiver()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(careBroadcastReceiver, intentFilter, RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(careBroadcastReceiver, intentFilter)
        }

    }

    private fun unregisterBroadCast() {
        if (careBroadcastReceiver != null) {
            unregisterReceiver(careBroadcastReceiver)
        }
    }

    private fun handleHelperApkInstall(filePathName: String) {
        val intent = Intent()
        intent.setAction(PACKAGE_INSTALLED_ACTION)
        intent.setPackage(packageName)
        Log.i(TAG, "handleHelperApkInstall() prepare install filePathName = $filePathName")
        val pendingIntent = PendingIntent.getBroadcast(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE)
        val success: Boolean = ApkTools.installApkSession(this, filePathName, pendingIntent.intentSender)
        if (!success) {
            sink?.success("HelperInstallFailed")
        }
    }


    inner class CareBroadcastReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (PACKAGE_INSTALLED_ACTION == intent.action) {
                val extras = intent.extras
                val status = extras!!.getInt(PackageInstaller.EXTRA_STATUS)
                Log.i(TAG, "onReceive install action, install status=$status")
                if (PackageInstaller.STATUS_SUCCESS == status) {
                    sink?.success("HelperInstalled")
                } else {
                    sink?.success("HelperInstallFailed")
                }
            }
        }
    }

    //====Printer======
    private var printer: Printer? = null
    private var isOnPrinterSearching: Boolean = false
    private var lastPrinterConnType: ConnectType? = null
    private var lastPrinterUid: String? = null
    private val printerFinder = PrinterFinder()

    override fun onPrinterConnected(printer: Printer?) {
        Log.i(TAG, "onPrinterConnected()")
        this.printer = printer
        if (printer != null) {
            Log.i(TAG, "onPrinterConnected() printer=${printer.printerDevice.printerName}, connectType=${printer.connectType}")
            if (printer.connectType == ConnectType.BLUETOOTH) {
                if (printer.printerDevice is BluetoothPrinterDevice) {
                    val bluetoothPrinter = printer.printerDevice as BluetoothPrinterDevice
                    Log.i(TAG, "onPrinterConnected() bluetoothPrinter=${bluetoothPrinter.bluetoothDevice.address}")
                    sink?.success("PrinterConnected_${printer.connectType}_${bluetoothPrinter.bluetoothDevice.address}")
                }
            } else if (printer.connectType == ConnectType.WIFI) {
                if (printer.printerDevice is WifiPrinterDevice) {
                    val wifiPrinterDevice = printer.printerDevice as WifiPrinterDevice
                    Log.i(TAG, "onPrinterConnected() wifiPrinterDevice=${wifiPrinterDevice.mac}, ip=${wifiPrinterDevice.ip}, port=${wifiPrinterDevice.port}")
                    sink?.success("PrinterConnected_${printer.connectType}_${wifiPrinterDevice.mac}_${wifiPrinterDevice.ip}_${wifiPrinterDevice.port}")
                }
            }
        }
    }

    override fun onPrinterConnectFail(printer: Printer?) {
        Log.i(TAG, "onPrinterConnectFail()")
    }

    override fun onPrinterDisconnect(printer: Printer?) {
        Log.i(TAG, "onPrinterDisconnect()")
        this.printer = null
    }

    private fun startSearchPrinterActivity() {
        val intent = Intent(this, PrinterConnectActivity::class.java)
        intent.putExtra("type", Constants.SearchTypeAll)
        startActivity(intent)
    }

    private fun isPrinterConnected(): Boolean {
        return printer != null && printer!!.isConnected
    }

    private fun startWifiPrinterConnect(ip: String, port: Int) {
        val wifiPrinter = WifiPrinterDevice()
        wifiPrinter.ip = ip
        wifiPrinter.port = 9100
        Printer.connect(wifiPrinter)
    }

    private fun startSearchPrinters() {
        printerFinder.searchPrinters(this)
        isOnPrinterSearching = true
    }

    private fun stopSearchPrinters() {
        printerFinder.stopSearchDevice()
        isOnPrinterSearching = false
    }

    override fun onSearchBluetoothPrinter(device: BluetoothPrinterDevice?) {
        Log.i(TAG, "onSearchBluetoothPrinter() $device")
        if (ConnectType.BLUETOOTH == lastPrinterConnType) {
            if (device != null && device.bluetoothDevice.address == lastPrinterUid) {
                // connect printer
                Printer.connect(device)
            }
        }
    }

    override fun onSearchUsbPrinter(device: UsbPrinterDevice?) {

    }

    override fun onSearchUsbPrinter(device: UsbAccessoryPrinterDevice?) {

    }

    override fun onSearchNetworkPrinter(device: WifiPrinterDevice?) {
        Log.i(TAG, "onSearchNetworkPrinter() $device")
        if (ConnectType.WIFI == lastPrinterConnType) {
            if (device != null && device.mac == lastPrinterUid) {
                // connect printer
                Printer.connect(device)
            }
        }
    }

    override fun onSearchSerialPortPrinter(device: SerialPortPrinterDevice?) {

    }

    override fun onSearchCompleted() {

    }

    private fun checkPrinterStatus(result: Result) {
        if (isPrinterConnected()) {
            printer!!.getPrinterStatus(Instruction.ESC) { printerState ->
                runOnUiThread{
                    //sink?.success("PrinterState_${printerState.status}")
                    result.success(printerState.status)
                }
            }
        } else {
            result.success(-1)
        }
    }

    private fun printEscDot(printContent: String): Boolean {
        if (isPrinterConnected()) {
            try {

                val gson = Gson()
                val orderDetailResp = gson.fromJson(printContent, OrderDetailResp::class.java)
                Log.i(TAG, "orderDetailResp=$orderDetailResp")
                for (list in orderDetailResp.getPrintList()) {
                    Log.i(TAG, "============>>>>>$list")
                    for (arrData in list) {
                        Log.i(TAG, "============>>>>>$arrData")
                    }
                }

                val esc: EscCommand = EscCommand()
                esc.addInitializePrinter()

                // 设置为倍高倍宽
                //字体放大两倍
                esc.addSetCharcterSize(EscCommand.WIDTH_ZOOM.MUL_2, EscCommand.HEIGHT_ZOOM.MUL_2)

                // 打印文字
                esc.addText("爱情餐厅\n\n")
                esc.addSelectJustification(EscCommand.JUSTIFICATION.LEFT)
                esc.addText("520号桌\n\n")

                //字体正常
                esc.addSetCharcterSize(EscCommand.WIDTH_ZOOM.MUL_1, EscCommand.HEIGHT_ZOOM.MUL_1)
                esc.addText("点菜时间 2020-05-20 5:20\n")
                esc.addText("上菜时间 2020-05-20 13:14\n")
                esc.addText("人数：2人 点菜员：新疆包工头\n")
                esc.addText("--------------------------------\n")
                esc.addText(printContent)
                esc.addText("--------------------------------\n")
                //开启加粗
                esc.addTurnEmphasizedModeOnOrOff(EscCommand.ENABLE.ON)
                esc.addText(MenuUtils.printFourData("菜名", "单价", "数量", "金额"))
                esc.addTurnEmphasizedModeOnOrOff(EscCommand.ENABLE.OFF)

                for (list in orderDetailResp.getPrintList()) {
                    if (list.size == 4) {
                        esc.addText(MenuUtils.printFourData(list[0], list[1], list[2], list[3]))
                    } else if (list.size == 3){
                        esc.addText(MenuUtils.printThreeData(list[0], list[1], list[2]))
                    }  else if (list.size == 2){
                        esc.addText(MenuUtils.printTwoData(list[0], list[1]))
                    }
                }

                //esc.addText(MenuUtils.printFourData("飞龙汤", "66.66", "1", "66.66"))
                //esc.addText(MenuUtils.printFourData("无为熏鸭", "88.88", "1", "88.88"))

                esc.addPrintAndLineFeed()
                esc.addPrintAndLineFeed()

                esc.addSelectJustification(EscCommand.JUSTIFICATION.CENTER)

                // 设置纠错等级
                esc.addSelectErrorCorrectionLevelForQRCode(0x31.toByte())

                // 设置qrcode模块大小
                esc.addSelectSizeOfModuleForQRCode(4.toByte())

                // 设置qrcode内容
                esc.addStoreQRCodeData("https://www.baidu.com")

                // 打印QRCode
                esc.addPrintQRCode()
                esc.addText("\n(扫二维码送手机)\n")
                esc.addText("\n\n\n\n")
                esc.addPrintAndLineFeed()

                //切纸（带切刀打印机才可用）
                esc.addCutPaper()
                printer!!.print(esc.getBytes(), null)
                return true;
            } catch (e: IOException) {
                e.printStackTrace()
                Log.i(TAG, "printEscDot() ${e.printStackTrace()}")
            }
            return false;
        }
        return false;
    }

}

