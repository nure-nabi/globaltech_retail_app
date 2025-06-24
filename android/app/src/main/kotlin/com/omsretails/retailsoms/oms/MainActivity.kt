package com.omsretails.retailsoms.oms


import android.app.Activity
import android.content.Context
import android.widget.Toast
import android.os.Handler
import android.os.Looper
import android.graphics.Paint
import com.example.clientapp.utils.BaseUtils;

import android.os.RemoteException
import android.os.Bundle
import android.util.Base64
import java.nio.charset.StandardCharsets
// BitmapDraw.kt
import com.example.clientapp.printer.BitmapDraw
import com.example.clientapp.printer.PrintSize


import com.example.clientapp.AppService
import com.example.clientapp.constant.PackageType
import acquire.client_connection.PaymentRequest
import acquire.client_connection.PaymentResponse
import acquire.client_connection.EcrPaymentResponse
import acquire.client_connection.IPaymentCallback

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import android.content.SharedPreferences

class MainActivity : FlutterFragmentActivity () {
    private val PREFS_NAME = "MyPrefs"
    private val myClass = AppService() // Instance of your class
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        AppServicePlugin().apply {
            setActivity(this@MainActivity)
            setupChannel(flutterEngine.dartExecutor.binaryMessenger)
        }
    }
}

class AppServicePlugin : MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    fun setupChannel(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, "com.example.clientapp")
        channel.setMethodCallHandler(this)
    }

    private fun tearDownChannel() {
        channel.setMethodCallHandler(null)
    }

    fun setActivity(activity: Activity?) {
        this.activity = activity
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (activity == null) {
            result.error("UNAVAILABLE", "Activity is null", null)
            return
        }

        when (call.method) {
            "initService" -> {
                AppService.me().init(activity!!.applicationContext)
                result.success(null)
            }
            "getPackage" -> {
                  AppService.me().setPackageName(PackageType.CPLUS)
                result.success(null)
            }
            "bindService" -> {
                 AppService.me().bindService()
                result.success(null)
            }
            "getSerialNumber" -> {
                val serialNumber = AppService.me().getSerialNumber()
                result.success(serialNumber)
            }
            "doLogon" -> {
                val doLogon =   AppService.me().doLogon()
                result.success(doLogon)
            }
            "launchApp" -> {
                val launchApp =   AppService.me().launchApp()
                result.success(launchApp)
            }
            "printReceipt" -> {
                val heading = call.argument<String>("heading") ?: ""
                val content = call.argument<String>("content") ?: ""
                val footer = call.argument<String>("footer") ?: ""
                val companyName = call.argument<String>("companyName") ?: ""
                val refrenceId = call.argument<String>("refrenceId") ?: ""
                val paymentMode = call.argument<String>("paymentMode") ?: ""


                //val stringHeading = StringBuilder()

                // stringHeading.append("SN.   ITEM     QTY  price AMOUNT")


                printReceipt2(heading, content, footer,companyName,refrenceId,paymentMode) { success, message ->
                    if (success) {
                        result.success(message)
                    } else {
                        result.error("PRINT_ERROR", message, null)
                    }
                }
            }
//            "settlement" -> {
//                AppService.me().startPrinting(base64StringValue, object : IPaymentCallback.Stub() {
//                    override fun onResponse(bundle: Bundle) {
//                        // Handle bundle response if needed
//                    }
//
//                    override fun onSuccess(b: Boolean, s: String) {
//                        // Handle response on main thread
//                        Handler(Looper.getMainLooper()).post {
//                            Toast.makeText(context, "Status: $b Message: $s", Toast.LENGTH_LONG).show()
//                        }
//                    }
//                })
//                AppService.me().doReconcilation(callback)
//            }
            "makeTransaction" -> {

                    val amount = call.argument<Double>("amount") ?: 0.0
                    val transType = call.argument<String>("transType") ?: ""
                    val remarks = call.argument<String>("remarks") ?: ""

                    if (amount >= 100000.00) {

                        result.error("INVALID_AMOUNT", "Amount exceeds limit", null)
                        return
                    }

                    val request = PaymentRequest().apply {
                        this.amount = (amount * 100).toLong()
                        this.transType = transType
                        this.paymentEntryMode = "transType"
                        this.remarks = remarks
                    }

                    val callback = object : IPaymentCallback.Stub() {

                        override fun onResponse(bundle: Bundle) {
                            // Handle bundle response if needed
                            // Convert Bundle to a Map that can be sent to Flutter
                            val resultMap = HashMap<String, Any?>()
                            for (key in bundle.keySet()) {
                                resultMap[key] = bundle.get(key)
                            }

                            // Send the result back to Flutter

                                result.success(resultMap)

                        }

                        override fun onSuccess(b: Boolean, s: String) {
                            // Handle response on main thread
                           // Handler(Looper.getMainLooper()).post {
                               // Toast.makeText(activity, "Status: $b Message: $s", Toast.LENGTH_LONG).show()
                           // }
                        }

//                        override fun onResponse(response: PaymentResponse) {
//
//                            // Create a map containing both message and resultCode resultCode
//                            val resultMap = hashMapOf<String, Any>(
//                                "message" to (response.message ?: ""),
//                                "ReferenceId" to response.referenceId
//                            )
//                            result.success(resultMap)
//                        }

//                        override fun onEcrResponse(ecrResponse: EcrPaymentResponse) {
//                            showRequestToast(
//                                "Payment Response" to "ERROR",
//                                "ECR Code" to ecrResponse.resultCode,
//                                "Error Message" to ecrResponse.message
//                            )
//                            result.error("ECR_ERROR", ecrResponse.message, null)
//                        }

//                        override fun onSuccess(b: Boolean, s: String) {
////                            showRequestToast(
////                                "Transaction Status" to if (b) "SUCCESS" else "FAILED",
////                                "Completion Message" to s
////                            )
//                            result.success(s)
//                        }
                    }

                    AppService.me().makeTransaction(request, callback)

            }
            "isServiceConnected" -> {
                val isServiceConnected: Boolean = AppService.me().isServiceConnected()

                result.success(isServiceConnected)
            }
            else -> result.notImplemented()
        }
    }



    // Function to show parameterized Toast
    private fun showRequestToast(vararg params: Pair<String, Any?>) {
        activity?.runOnUiThread {
            val toastMessage = StringBuilder("Request Parameters:\n")
            params.forEach { (key, value) ->
                toastMessage.append("$key: $value\n")
            }
            Toast.makeText(activity, toastMessage.toString(), Toast.LENGTH_LONG).show()
        }
    }

    private fun processPayment(request: PaymentRequest) {
        // Handle payment logic
        println("Processing payment: ${request.amount}")
    }

//    fun printReceipt(
//        heading: String,
//        content: String,
//        footer: String,
//        companyName: String,
//        refrenceId: String,
//        paymentMode: String,
//        callback: (Boolean, String) -> Unit
//    ) {
//        try {
//
//            val bitmapDraw = BitmapDraw().apply {
//                text(companyName, PrintSize.CONTENT.toFloat(), true, Paint.Align.CENTER)
//                text(refrenceId, PrintSize.CONTENT.toFloat(), true, Paint.Align.LEFT)
//                text(paymentMode, PrintSize.CONTENT.toFloat(), true, Paint.Align.LEFT)
//                text(heading, PrintSize.NORMAL.toFloat(), true, Paint.Align.CENTER)
//                text("-------------------------------------------------------------", PrintSize.NORMAL.toFloat(), true, Paint.Align.CENTER)
//                text(content, PrintSize.SMALL_CONTENT.toFloat(), true, Paint.Align.LEFT)
//                text("Total",footer, PrintSize.LINE.toFloat(), true)
//                text("----------------------------------------------------------", PrintSize.CONTENT.toFloat(), true, Paint.Align.CENTER)
//                feedPaper(PrintSize.TAIL_FEED.toFloat())
//            }
//            // Get the Bitmap and pass it to startPrinting
//            val receiptBitmap = bitmapDraw.getBitmap()
//            AppService.me().startPrinting(
//                receiptBitmap,  // Pass the Bitmap directly
//                false,         // isHeaderRequired (adjust as needed)
//                object : IPaymentCallback.Stub() {
//                    override fun onResponse(response: PaymentResponse) {
//                        callback(true, response.message)
//                    }
//                    override fun onEcrResponse(ecrResponse: EcrPaymentResponse) {
//                        callback(false, ecrResponse.message)
//                    }
//                    override fun onSuccess(success: Boolean, message: String) {
//                        callback(success, message)
//                    }
//                }
//            )
//        } catch (e: Exception) {
//            callback(false, e.message ?: "Unknown error")
//        }
//    }

    fun printReceipt2(
        heading: String,
        content: String,
        footer: String,
        companyName: String,
        refrenceId: String,
        paymentMode: String,
        callback: (Boolean, String) -> Unit
    ) {
        try {
            val base64StringValue = encodeToBase64(content.toString())
            //Toast.makeText(activity, encodeToBase64(content).toString(), Toast.LENGTH_LONG).show()
            AppService.me().startPrinting(base64StringValue,30, object : IPaymentCallback.Stub() {
                @Throws(RemoteException::class)
                override fun onResponse(bundle: Bundle) {
                }
                @Throws(RemoteException::class)
                override fun onSuccess(b: Boolean, s: String) {
                    Handler(Looper.getMainLooper()).post {
                        Toast.makeText(activity, "Status: $b M essage: $s", Toast.LENGTH_LONG).show()
                    }
                }
            })

            // Create a bitmap with your receipt content
//            val original: String = "Hello Flutter!"
//            //val base64String: String = base64Encode(utf8.encode(original))
//           // Toast.makeText(activity, encodeToBase64(content).toString(), Toast.LENGTH_LONG).show()
//            AppService.me().startPrinting(
//                "aGVsbG8gZXZlcnlvbmUgdGhpcyBpcyBoIHRvIHRoZSB1c2t5IGh1c2t5IGhlcmU=",
//                object : IPaymentCallback.Stub() {
//                    override fun onResponse(response: PaymentResponse) {
//                        callback(true, response.message)
//                    }
//                    override fun onEcrResponse(ecrResponse: EcrPaymentResponse) {
//                        callback(false, ecrResponse.message)
//                    }
//                    override fun onSuccess(success: Boolean, message: String) {
//                        callback(success, message)
//                    }
//                }
//            )
        } catch (e: Exception) {
            callback(false, e.message ?: "Unknown error")
        }
    }

    fun encodeToBase64(input: String): String {
        return Base64.encodeToString(input.toByteArray(Charsets.UTF_8), Base64.NO_WRAP)
    }

//    fun printReceipt(
//        heading: String,
//        content: String,
//        footer: String,
//        callback: (Boolean, String) -> Unit
//    ) {
//        try {
//            val bitmapDraw = BitmapDraw().apply {
//                text(heading, PrintSize.CONTENT.toFloat(), true, Paint.Align.CENTER)
//                text(content, PrintSize.CONTENT.toFloat(), true, Paint.Align.CENTER)
//                text("---$footer---", PrintSize.LINE.toFloat(), true, Paint.Align.CENTER)
//                feedPaper(PrintSize.TAIL_FEED.toFloat())
//            }
//
//
//            AppService.me().startPrinting(
//                bitmapDraw.getBitmap(),
//                true,// Ensure this matches expected param type
//                object : IPaymentCallback.Stub() {
//                    override fun onResponse(response: PaymentResponse) {
//                        showOnUiThread("Print response: ${response.message}") {
//                            callback(true, response.message)
//                        }
//                    }
//
//                    override fun onEcrResponse(ecrResponse: EcrPaymentResponse) {
//                        showOnUiThread("Print error: ${ecrResponse.message}") {
//                            callback(false, ecrResponse.message)
//                        }
//                    }
//
//                    override fun onSuccess(success: Boolean, message: String) {
//                        showOnUiThread("Print ${if (success) "success" else "failedAA"}: $message") {
//                            callback(success, message)
//                        }
//                    }
//                }
//            )
//        } catch (e: Exception) {
//            showOnUiThread("Print failedSS: ${e.message}") {
//                callback(false, e.message ?: "Unknown error")
//            }
//        }
//    }
//
//    private fun showOnUiThread(message: String, action: () -> Unit = {}) {
//        Handler(Looper.getMainLooper()).post {
//            Toast.makeText(activity, message, Toast.LENGTH_LONG).show()
//            action()
//        }
//    }

}



