package com.wameedpos.provider

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.os.Build
import android.os.Binder
import android.os.Bundle
import android.os.IBinder
import android.os.Parcel
import android.util.Log
import dalvik.system.DexClassLoader
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.lang.reflect.InvocationHandler
import java.lang.reflect.Proxy
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import java.util.UUID
import kotlin.math.ceil

class MainActivity : FlutterFragmentActivity() {
    private val tag = "WameedPosNative"

    private data class BoundOmniDriver(val binder: IBinder, val connection: ServiceConnection)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "wameedpos/bluetooth")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Return all bonded (paired) Bluetooth devices — no scan needed.
                    "getBondedDevices" -> {
                        try {
                            val adapter = bluetoothAdapter()
                            val devices = adapter?.bondedDevices?.map { d ->
                                mapOf("name" to (d.name ?: "Unknown"), "address" to d.address)
                            } ?: emptyList()
                            result.success(devices)
                        } catch (_: SecurityException) {
                            result.success(emptyList<Map<String, Any>>())
                        } catch (e: Exception) {
                            result.success(emptyList<Map<String, Any>>())
                        }
                    }
                    // Print raw ESC/POS bytes to a built-in serial/USB printer.
                    "printSerial" -> {
                        val path  = call.argument<String>("path")
                        val bytes = call.argument<ByteArray>("data")
                        if (path == null || bytes == null) {
                            result.error("INVALID_ARGS", "path and data required", null)
                            return@setMethodCallHandler
                        }
                        Thread {
                            val ok = if (isLandiDevice()) {
                                printOmniDriverText(escPosToText(bytes))
                            } else {
                                printRawDevice(path, bytes)
                            }
                            result.success(ok)
                        }.start()
                    }
                    "printSerialText" -> {
                        val path = call.argument<String>("path")
                        val text = call.argument<String>("text")
                        val qr = call.argument<String>("qr")
                        if (path == null || text == null) {
                            result.error("INVALID_ARGS", "path and text required", null)
                            return@setMethodCallHandler
                        }
                        Thread {
                            val fallback = text.toByteArray(Charsets.UTF_8)
                            val ok = if (isLandiDevice()) {
                                printOmniDriverText(text, qr)
                            } else {
                                printRawDevice(path, fallback)
                            }
                            result.success(ok)
                        }.start()
                    }
                    // Print raw ESC/POS bytes to a Classic-BT (SPP) printer.
                    "printBluetooth" -> {
                        val address = call.argument<String>("address")
                        val bytes   = call.argument<ByteArray>("data")
                        if (address == null || bytes == null) {
                            result.error("INVALID_ARGS", "address and data required", null)
                            return@setMethodCallHandler
                        }
                        Thread {
                            var ok = false
                            try {
                                val adapter = bluetoothAdapter()
                                val device = adapter?.getRemoteDevice(address)
                                val uuid = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")
                                val socket = device?.createRfcommSocketToServiceRecord(uuid)
                                socket?.connect()
                                socket?.outputStream?.write(bytes)
                                socket?.outputStream?.flush()
                                socket?.close()
                                ok = true
                            } catch (_: Exception) {}
                            result.success(ok)
                        }.start()
                    }
                    // Returns the EdfaPay device ID derived from Settings.Secure.ANDROID_ID.
                    // Format: {id[0:8]}-{id[8:12]}-{id[12:16]}-0000-0000{id[8:16]}
                    "getDeviceId" -> {
                        try {
                            val androidId = android.provider.Settings.Secure.getString(
                                contentResolver,
                                android.provider.Settings.Secure.ANDROID_ID,
                            ) ?: "0000000000000000"
                            // Pad to exactly 16 hex chars so slicing is safe.
                            val id = androidId.padStart(16, '0').takeLast(16)
                            val edfapayId = "${id.substring(0, 8)}-${id.substring(8, 12)}-${id.substring(12, 16)}-0000-0000${id.substring(8, 16)}"
                            result.success(edfapayId)
                        } catch (e: Exception) {
                            result.error("ERROR", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun bluetoothAdapter(): BluetoothAdapter? =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
            (getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager)?.adapter
        else
            @Suppress("DEPRECATION") BluetoothAdapter.getDefaultAdapter()

    private fun isLandiDevice(): Boolean = Build.MANUFACTURER.equals("LANDI", ignoreCase = true)

    private fun printRawDevice(path: String, bytes: ByteArray): Boolean {
        return try {
            FileOutputStream(path).use { fos ->
                fos.write(bytes)
                fos.flush()
            }
            Log.i(tag, "Raw printer write succeeded: path=$path bytes=${bytes.size}")
            true
        } catch (e: Exception) {
            Log.e(tag, "Raw printer write failed: path=$path bytes=${bytes.size}", e)
            false
        }
    }

    private fun printOmniDriverText(text: String, qr: String? = null): Boolean {
        val receiptText = text.trimEnd()
        if (!isLandiDevice() || receiptText.isBlank()) return false

        val sdkApk = File("/system_ext/app/omnidriver-service/omnidriver-service.apk")
        if (!sdkApk.exists()) return false

        val boundService = bindOmniDriverService() ?: return false
        val loader = DexClassLoader(
            sdkApk.absolutePath,
            codeCacheDir.absolutePath,
            null,
            classLoader,
        )

        try {
            val omniStub = loader.loadClass("com.sdksuite.omnidriver.aidl.IOmniDriver\$Stub")
            val omni = omniStub.getMethod("asInterface", IBinder::class.java).invoke(null, boundService.binder)
                ?: return false
            val omniClass = omni.javaClass

            try {
                omniClass.getMethod("init", Bundle::class.java, IBinder::class.java)
                    .invoke(omni, Bundle(), Binder())
            } catch (e: Throwable) {
                Log.w(tag, "OmniDriver init failed; continuing", e)
            }

            if (printOmniDriverCanvasImage(omniClass, omni, loader, receiptText, qr)) {
                return true
            }

            Log.w(tag, "OmniDriver canvas image print failed; trying canvas text fallback")
            if (printOmniDriverCanvasText(omniClass, omni, loader, receiptText)) {
                return true
            }

            Log.w(tag, "OmniDriver canvas print failed; trying positioned text fallback")
            return printOmniDriverPositionedText(omniClass, omni, loader, receiptText)
        } catch (e: Throwable) {
            Log.e(tag, "OmniDriver print failed", e)
            return false
        } finally {
            try {
                unbindService(boundService.connection)
            } catch (_: Throwable) {}
        }
    }

    private fun printOmniDriverCanvasImage(
        omniClass: Class<*>,
        omni: Any,
        loader: DexClassLoader,
        receiptText: String,
        qr: String?,
    ): Boolean {
        val receiptBitmap = buildReceiptBitmap(receiptText, qr, loader)
        var printer: Any? = null

        return try {
            val printerBundle = Bundle().apply { putInt("type", 2) }
            val printerBinder = omniClass.getMethod("getPrinter", Bundle::class.java).invoke(omni, printerBundle) as? IBinder
            if (printerBinder == null) {
                Log.w(tag, "OmniDriver canvas image getPrinter returned null")
                return false
            }

            val printerStub = loader.loadClass("com.sdksuite.omnidriver.aidl.printer.ICanvasPrinter\$Stub")
            printer = printerStub.getMethod("asInterface", IBinder::class.java).invoke(null, printerBinder)
                ?: return false

            val baseOptionClass = loader.loadClass("com.sdksuite.omnidriver.aidl.printer.BaseOption")
            val imageStyleClass = loader.loadClass("com.sdksuite.omnidriver.aidl.printer.ImageStyle")
            val baseOption = baseOptionClass.getConstructor().newInstance()
            setIntProperty(baseOption, "setWidth", receiptBitmap.width)
            setIntProperty(baseOption, "setHeight", receiptBitmap.height)
            setIntProperty(baseOption, "setGray", 8)

            val imageStyle = imageStyleClass.getConstructor().newInstance()
            setIntProperty(imageStyle, "setPointX", 0)
            setIntProperty(imageStyle, "setPointY", 0)
            setIntProperty(imageStyle, "setWidth", receiptBitmap.width)
            setIntProperty(imageStyle, "setHeight", receiptBitmap.height)
            setIntProperty(imageStyle, "setRotation", 0)

            if (!invokeOmniResult(printer, "openDevice", arrayOf(Int::class.javaPrimitiveType!!), 0)) return false
            if (!invokeOmniResult(printer, "init", arrayOf(baseOptionClass), baseOption)) return false
            if (!invokeOmniResult(printer, "renderImage", arrayOf(Bitmap::class.java, imageStyleClass), receiptBitmap, imageStyle)) {
                return false
            }

            val printed = startOmniPrint(printer, loader, "canvas image")
            if (printed) {
                Log.i(tag, "OmniDriver canvas image print succeeded: chars=${receiptText.length} bitmap=${receiptBitmap.width}x${receiptBitmap.height}")
            }
            printed
        } catch (throwable: Throwable) {
            Log.e(tag, "OmniDriver canvas image print failed", throwable)
            false
        } finally {
            if (printer != null) {
                invokeOmniResult(printer, "closeDevice", emptyArray())
            }
        }
    }

    private fun buildReceiptBitmap(receiptText: String, qrData: String?, loader: ClassLoader): Bitmap {
        val paperWidth = 576
        val horizontalPadding = 10f
        val verticalPadding = 12f
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.BLACK
            textSize = 24f
            typeface = Typeface.create(Typeface.MONOSPACE, Typeface.BOLD)
            textScaleX = 0.86f
            isFakeBoldText = true
        }
        val fontMetrics = paint.fontMetrics
        val lineHeight = ceil(fontMetrics.descent - fontMetrics.ascent + 8f).toInt()
        val drawableWidth = paperWidth - (horizontalPadding * 2)
        val wrappedLines = receiptText.lines().flatMap { line -> wrapReceiptLine(line, paint, drawableWidth) }
        val textHeight = verticalPadding.toInt() * 2 + (wrappedLines.size + 1) * lineHeight

        // Encode the ZATCA/QR payload (if any) so we can reserve space below the
        // text and draw it as a real scannable code rather than printing TLV text.
        val qrMatrix = if (!qrData.isNullOrBlank()) encodeQrMatrix(loader, qrData, 320) else null
        val qrSize = qrMatrix?.size ?: 0
        val qrBlockHeight = if (qrSize > 0) qrSize + lineHeight * 2 else 0

        val bitmapHeight = (textHeight + qrBlockHeight + lineHeight * 2).coerceAtLeast(lineHeight * 4)
        val bitmap = Bitmap.createBitmap(paperWidth, bitmapHeight, Bitmap.Config.RGB_565)
        val canvas = Canvas(bitmap)
        canvas.drawColor(Color.WHITE)

        var baseline = verticalPadding - fontMetrics.ascent
        for (line in wrappedLines) {
            if (line.isNotEmpty()) {
                canvas.drawText(line, horizontalPadding, baseline, paint)
                canvas.drawText(line, horizontalPadding + 1f, baseline, paint)
            }
            baseline += lineHeight
        }

        // Draw the QR centered below the text block.
        if (qrMatrix != null && qrSize > 0) {
            val left = (paperWidth - qrSize) / 2
            val top = textHeight + lineHeight
            val cellPaint = Paint().apply {
                color = Color.BLACK
                style = Paint.Style.FILL
                isAntiAlias = false
            }
            for (y in qrMatrix.indices) {
                val row = qrMatrix[y]
                for (x in row.indices) {
                    if (row[x]) {
                        val px = (left + x).toFloat()
                        val py = (top + y).toFloat()
                        canvas.drawRect(px, py, px + 1f, py + 1f, cellPaint)
                    }
                }
            }
        }

        return bitmap
    }

    /// Encode [data] to a square QR bit matrix using the ZXing classes bundled
    /// inside the Omnidriver APK (loaded via [loader]). Returns null on failure.
    private fun encodeQrMatrix(loader: ClassLoader, data: String, size: Int): Array<BooleanArray>? {
        return try {
            val writerClass = loader.loadClass("com.google.zxing.qrcode.QRCodeWriter")
            val formatClass = loader.loadClass("com.google.zxing.BarcodeFormat")
            val qrFormat = formatClass.getField("QR_CODE").get(null)
            val writer = writerClass.getConstructor().newInstance()
            val encode = writerClass.getMethod(
                "encode",
                String::class.java,
                formatClass,
                Int::class.javaPrimitiveType!!,
                Int::class.javaPrimitiveType!!,
            )
            val matrix = encode.invoke(writer, data, qrFormat, size, size) ?: return null
            val matrixClass = matrix.javaClass
            val width = matrixClass.getMethod("getWidth").invoke(matrix) as Int
            val height = matrixClass.getMethod("getHeight").invoke(matrix) as Int
            val get = matrixClass.getMethod("get", Int::class.javaPrimitiveType!!, Int::class.javaPrimitiveType!!)
            Array(height) { y -> BooleanArray(width) { x -> get.invoke(matrix, x, y) as Boolean } }
        } catch (e: Throwable) {
            Log.w(tag, "QR encode failed", e)
            null
        }
    }

    private fun wrapReceiptLine(line: String, paint: Paint, maxWidth: Float): List<String> {
        if (line.isEmpty()) return listOf("")
        val wrapped = mutableListOf<String>()
        var remaining = line
        while (remaining.isNotEmpty()) {
            val count = paint.breakText(remaining, true, maxWidth, null).coerceAtLeast(1)
            wrapped.add(remaining.take(count).trimEnd())
            remaining = remaining.drop(count).trimStart()
        }
        return wrapped
    }

    private fun printOmniDriverCanvasText(
        omniClass: Class<*>,
        omni: Any,
        loader: DexClassLoader,
        receiptText: String,
    ): Boolean {
        val paperWidth = 576
        val horizontalPadding = 8
        val lineHeight = 34
        val fontSize = 24
        val printableLines = receiptText.lines()
        val canvasHeight = ((printableLines.size + 3) * lineHeight).coerceAtLeast(lineHeight * 4)
        var printer: Any? = null

        return try {
            val printerBundle = Bundle().apply { putInt("type", 2) }
            val printerBinder = omniClass.getMethod("getPrinter", Bundle::class.java).invoke(omni, printerBundle) as? IBinder
            if (printerBinder == null) {
                Log.w(tag, "OmniDriver canvas getPrinter returned null")
                return false
            }

            val printerStub = loader.loadClass("com.sdksuite.omnidriver.aidl.printer.ICanvasPrinter\$Stub")
            printer = printerStub.getMethod("asInterface", IBinder::class.java).invoke(null, printerBinder)
                ?: return false

            val baseOptionClass = loader.loadClass("com.sdksuite.omnidriver.aidl.printer.BaseOption")
            val textStyleClass = loader.loadClass("com.sdksuite.omnidriver.aidl.printer.TextStyle")
            val baseOption = baseOptionClass.getConstructor().newInstance()
            setIntProperty(baseOption, "setWidth", paperWidth)
            setIntProperty(baseOption, "setHeight", canvasHeight)
            setIntProperty(baseOption, "setGray", 4)

            if (!invokeOmniResult(printer, "openDevice", arrayOf(Int::class.javaPrimitiveType!!), 0)) return false
            if (!invokeOmniResult(printer, "init", arrayOf(baseOptionClass), baseOption)) return false

            var pointY = 0
            for (line in printableLines) {
                if (line.isNotBlank()) {
                    val style = textStyleClass.getConstructor().newInstance()
                    setIntProperty(style, "setFontSize", fontSize)
                    setIntProperty(style, "setTextColor", 0)
                    setIntProperty(style, "setPointX", horizontalPadding)
                    setIntProperty(style, "setPointY", pointY)
                    setIntProperty(style, "setWidth", paperWidth - (horizontalPadding * 2))
                    setIntProperty(style, "setHeight", lineHeight)
                    setIntProperty(style, "setAlign", 0)
                    if (!invokeOmniResult(printer, "renderText", arrayOf(String::class.java, textStyleClass), line, style)) {
                        return false
                    }
                }
                pointY += lineHeight
            }

            val printed = startOmniPrint(printer, loader, "canvas")
            if (printed) {
                Log.i(tag, "OmniDriver canvas print succeeded: chars=${receiptText.length} lines=${printableLines.size}")
            }
            printed
        } catch (throwable: Throwable) {
            Log.e(tag, "OmniDriver canvas print failed", throwable)
            false
        } finally {
            if (printer != null) {
                invokeOmniResult(printer, "closeDevice", emptyArray())
            }
        }
    }

    private fun printOmniDriverPositionedText(
        omniClass: Class<*>,
        omni: Any,
        loader: DexClassLoader,
        receiptText: String,
    ): Boolean {
        var printer: Any? = null

        return try {
            val printerBinder = omniClass.getMethod("getPrinter", Bundle::class.java).invoke(omni, Bundle()) as? IBinder
            if (printerBinder == null) {
                Log.w(tag, "OmniDriver positioned getPrinter returned null")
                return false
            }

            val printerStub = loader.loadClass("com.sdksuite.omnidriver.aidl.printer.IPrinter\$Stub")
            printer = printerStub.getMethod("asInterface", IBinder::class.java).invoke(null, printerBinder)
                ?: return false

            if (!invokeOmniResult(printer, "openDevice", arrayOf(Int::class.javaPrimitiveType!!), 0)) return false
            invokeOmniResult(printer, "setGray", arrayOf(Int::class.javaPrimitiveType!!), 4)

            for (line in receiptText.lines()) {
                if (line.isBlank()) {
                    invokeOmniResult(printer, "feedLine", arrayOf(Int::class.javaPrimitiveType!!), 1)
                } else if (!invokeOmniResult(
                        printer,
                        "addText",
                        arrayOf(Int::class.javaPrimitiveType!!, Int::class.javaPrimitiveType!!, String::class.java),
                        0,
                        0,
                        line,
                    )
                ) {
                    return false
                }
            }
            invokeOmniResult(printer, "feedLine", arrayOf(Int::class.javaPrimitiveType!!), 4)

            val printed = startOmniPrint(printer, loader, "positioned")
            if (printed) {
                Log.i(tag, "OmniDriver positioned print succeeded: chars=${receiptText.length}")
            }
            printed
        } catch (throwable: Throwable) {
            Log.e(tag, "OmniDriver positioned print failed", throwable)
            false
        } finally {
            if (printer != null) {
                invokeOmniResult(printer, "closeDevice", emptyArray())
            }
        }
    }

    private fun startOmniPrint(printer: Any, loader: ClassLoader, mode: String): Boolean {
        val listenerClass = loader.loadClass("com.sdksuite.omnidriver.aidl.printer.OnPrintListener")
        val callbackLatch = CountDownLatch(1)
        val callbackOk = booleanArrayOf(false)
        val callbackError = intArrayOf(0)
        val listener = omniPrintListener(loader, listenerClass, callbackLatch, callbackOk, callbackError)

        if (!invokeOmniResult(printer, "startPrint", arrayOf(listenerClass), listener)) return false
        val finished = callbackLatch.await(8, TimeUnit.SECONDS)
        return if (!finished) {
            Log.w(tag, "OmniDriver $mode print callback timed out")
            false
        } else if (!callbackOk[0]) {
            Log.w(tag, "OmniDriver $mode print callback failed: code=${callbackError[0]}")
            false
        } else {
            true
        }
    }

    private fun setIntProperty(target: Any, methodName: String, value: Int) {
        target.javaClass.getMethod(methodName, Int::class.javaPrimitiveType!!).invoke(target, value)
    }

    private fun bindOmniDriverService(): BoundOmniDriver? {
        val latch = CountDownLatch(1)
        val binderRef = arrayOfNulls<IBinder>(1)
        val connection = object : ServiceConnection {
            override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
                binderRef[0] = service
                latch.countDown()
            }

            override fun onServiceDisconnected(name: ComponentName?) {
                binderRef[0] = null
            }
        }

        val intent = Intent("sdksuite-omnidriver").apply {
            component = ComponentName("com.sdksuite.omnidriver", "com.sdksuite.omnidriver.OmniDriverService")
        }

        var didBind = false
        return try {
            if (!bindService(intent, connection, Context.BIND_AUTO_CREATE)) {
                Log.w(tag, "OmniDriver bindService returned false")
                return null
            }
            didBind = true
            if (!latch.await(4, TimeUnit.SECONDS)) {
                Log.w(tag, "OmniDriver bind timed out")
                unbindService(connection)
                return null
            }
            val binder = binderRef[0]
            if (binder == null) {
                unbindService(connection)
                return null
            }
            BoundOmniDriver(binder, connection)
        } catch (e: Throwable) {
            if (didBind) {
                try {
                    unbindService(connection)
                } catch (_: Throwable) {}
            }
            Log.e(tag, "OmniDriver bind failed", e)
            null
        }
    }

    private fun invokeOmniResult(target: Any, method: String, parameterTypes: Array<Class<*>>, vararg args: Any?): Boolean {
        return try {
            val result = target.javaClass.getMethod(method, *parameterTypes).invoke(target, *args)
            val isFail = result?.javaClass?.getMethod("isFail")?.invoke(result) as? Boolean
            val code = result?.javaClass?.getMethod("getCode")?.invoke(result) as? Int
            val message = result?.javaClass?.getMethod("getMessage")?.invoke(result) as? String
            if (isFail == true || (code != null && code != 0)) {
                Log.w(tag, "OmniDriver $method failed: code=$code message=$message")
                false
            } else {
                true
            }
        } catch (e: Throwable) {
            Log.e(tag, "OmniDriver $method threw", e)
            false
        }
    }

    private fun omniPrintListener(
        loader: ClassLoader,
        listenerClass: Class<*>,
        latch: CountDownLatch,
        callbackOk: BooleanArray,
        callbackError: IntArray,
    ): Any {
        val descriptor = "com.sdksuite.omnidriver.aidl.printer.OnPrintListener"
        val binder = object : Binder() {
            override fun onTransact(code: Int, data: Parcel, reply: Parcel?, flags: Int): Boolean {
                return when (code) {
                    IBinder.INTERFACE_TRANSACTION -> {
                        reply?.writeString(descriptor)
                        true
                    }
                    1 -> {
                        data.enforceInterface(descriptor)
                        callbackOk[0] = true
                        latch.countDown()
                        reply?.writeNoException()
                        true
                    }
                    2 -> {
                        data.enforceInterface(descriptor)
                        callbackOk[0] = false
                        callbackError[0] = data.readInt()
                        latch.countDown()
                        reply?.writeNoException()
                        true
                    }
                    else -> super.onTransact(code, data, reply, flags)
                }
            }
        }

        return Proxy.newProxyInstance(
            loader,
            arrayOf(listenerClass),
            InvocationHandler { _, method, args ->
                when (method.name) {
                    "asBinder" -> binder
                    "onFinish" -> {
                        callbackOk[0] = true
                        latch.countDown()
                        null
                    }
                    "onFail" -> {
                        callbackOk[0] = false
                        callbackError[0] = (args?.firstOrNull() as? Int) ?: -1
                        latch.countDown()
                        null
                    }
                    "toString" -> "WameedPosOmniPrintListener"
                    else -> null
                }
            },
        )
    }

    private fun escPosToText(bytes: ByteArray): String {
        val text = StringBuilder()
        var index = 0
        while (index < bytes.size) {
            val value = bytes[index].toInt() and 0xFF
            when {
                value == 0x0A || value == 0x0D -> text.append('\n')
                value in 0x20..0x7E -> text.append(value.toChar())
                value >= 0x80 -> text.append(value.toChar())
            }
            index++
        }
        return text.toString()
            .replace(Regex("[\\u001B\\u001D][^\\n]*"), "")
            .replace(Regex("\\n{4,}"), "\n\n\n")
    }

}
