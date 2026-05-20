package com.clearviewhub.app

import android.content.Context
import android.provider.Settings
import android.util.Log

object SystemWriteChannel {
    private const val TAG = "SystemWriteChannel"

    /**
     * Source: JAMA Ophthalmology 2024 - Adjusting font scale based on viewing distance.
     * Note: Requires android.permission.WRITE_SETTINGS
     */
    fun updateFontScale(context: Context, scale: Float): Boolean {
        return try {
            if (Settings.System.canWrite(context)) {
                Settings.System.putFloat(context.contentResolver, Settings.System.FONT_SCALE, scale)
                Log.d(TAG, "Font scale updated to: $scale")
                true
            } else {
                Log.e(TAG, "Cannot write settings. Permission not granted.")
                false
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error updating font scale", e)
            false
        }
    }
}
