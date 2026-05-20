package com.clearviewhub.app

import android.util.Log

/**
 * BlinkEngine: Detects blinks and calculates PERCLOS drowsiness.
 * Sources: MobiSys 2025, Springer BlinkDetector 2023.
 */
class BlinkEngine {
    private var blinkCount = 0
    private var framesWithEyesClosed = 0
    private var totalFrames = 0
    private val blinkThreshold = 0.25f // Probability threshold for eye closed
    
    private var isEyeClosed = false

    /**
     * Process face detection result. 
     * @param leftEyeProb Probability that left eye is open (0.0 to 1.0)
     * @param rightEyeProb Probability that right eye is open (0.0 to 1.0)
     */
    fun processFrame(leftEyeProb: Float?, rightEyeProb: Float?) {
        if (leftEyeProb == null || rightEyeProb == null) return

        totalFrames++
        val avgOpenProb = (leftEyeProb + rightEyeProb) / 2.0f

        if (avgOpenProb < blinkThreshold) {
            framesWithEyesClosed++
            if (!isEyeClosed) {
                isEyeClosed = true
                blinkCount++
            }
        } else {
            isEyeClosed = false
        }
    }

    /**
     * PERCLOS: Percentage of eye closure time.
     * Drowsiness threshold > 15% as per Springer BlinkDetector 2023.
     */
    fun getPerclos(): Float {
        if (totalFrames == 0) return 0f
        return framesWithEyesClosed.toFloat() / totalFrames.toFloat()
    }

    fun getBlinkCount(): Int = blinkCount

    fun resetStats() {
        blinkCount = 0
        framesWithEyesClosed = 0
        totalFrames = 0
    }
}
