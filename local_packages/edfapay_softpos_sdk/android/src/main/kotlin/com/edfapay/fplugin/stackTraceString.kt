package com.edfapay.fplugin

import java.io.PrintWriter
import java.io.StringWriter

fun Throwable.stackTraceString(): String {
    val sw = StringWriter()
    val pw = PrintWriter(sw)
    this.printStackTrace(pw)
    return sw.toString()
}