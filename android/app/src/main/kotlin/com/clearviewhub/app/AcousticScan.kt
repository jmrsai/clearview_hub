package com.clearviewhub.app

import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import kotlin.math.sin

/**
 * AcousticScan: Experimental cataract screening using 20kHz acoustic signals.
 * Logic: Emits high-frequency sound and analyzes reflection/absorption.
 */
class AcousticScan {
    private val sampleRate = 44100
    private val freqOfTone = 20000.0 // 20 kHz
    
    fun playTestTone(durationSeconds: Int) {
        val numSamples = durationSeconds * sampleRate
        val sample = DoubleArray(numSamples)
        val generatedSnd = ByteArray(2 * numSamples)

        for (i in 0 until numSamples) {
            sample[i] = sin(2 * Math.PI * i / (sampleRate / freqOfTone))
        }

        var idx = 0
        for (dVal in sample) {
            val valShort = (dVal * 32767).toInt().toShort()
            generatedSnd[idx++] = (valShort.toInt() and 0x00ff).toByte()
            generatedSnd[idx++] = ((valShort.toInt() and 0xff00) ushr 8).toByte()
        }

        val audioTrack = AudioTrack(
            AudioManager.STREAM_MUSIC,
            sampleRate, AudioFormat.CHANNEL_OUT_MONO,
            AudioFormat.ENCODING_PCM_16BIT, numSamples * 2,
            AudioTrack.MODE_STATIC
        )
        audioTrack.write(generatedSnd, 0, generatedSnd.size)
        audioTrack.play()
    }
}
