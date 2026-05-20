package com.clearviewhub.app

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.provider.Settings
import android.util.Log

/**
 * AccessService: Detects high-dopamine apps (TikTok/IG) and enforces Grayscale Lock.
 */
class AccessService : AccessibilityService() {

    private val addictiveApps = listOf("com.zhiliaoapp.musically", "com.instagram.android")
    private var startTime: Long = 0

    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString() ?: return
            
            if (addictiveApps.contains(packageName)) {
                Log.d("AccessService", "Addictive app detected: $packageName")
                // In a real implementation, we would track time and then trigger grayscale
                // For this prototype, we'll demonstrate the DALTONIZER trigger logic
                enableGrayscale(true)
            } else {
                enableGrayscale(false)
            }
        }
    }

    private fun enableGrayscale(enable: Boolean) {
        try {
            // accessibility_display_daltonizer_enabled = 1 (on), 0 (off)
            // accessibility_display_daltonizer = 0 (grayscale)
            Settings.Secure.putInt(contentResolver, "accessibility_display_daltonizer_enabled", if (enable) 1 else 0)
            Settings.Secure.putInt(contentResolver, "accessibility_display_daltonizer", 0)
        } catch (e: Exception) {
            Log.e("AccessService", "Failed to set grayscale. Needs WRITE_SECURE_SETTINGS via ADB.", e)
        }
    }

    override fun onInterrupt() {}
}
