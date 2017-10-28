package beach3dals.com.powerofus

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import java.lang.String.valueOf

class MainActivity : AppCompatActivity(), SensorEventListener {

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    lateinit var sm: SensorManager
    lateinit var textInfo: TextView
    lateinit var textView: TextView
    lateinit var sensorX: TextView
    lateinit var sensorY: TextView
    lateinit var sensorZ: TextView
    lateinit var button: Button
    var a=0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        sm = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        sensorX = findViewById(R.id.x)
        sensorY = findViewById(R.id.y)
        sensorZ = findViewById(R.id.z)
        button = findViewById(R.id.button)

        button.setOnClickListener{


            if(a==0){
                onPause()
                a = 1
                button.setText("start")
            }else if(a==1) {
                onResume()
                a = 0
                button.setText("stop")
            }
        }

    }


    override fun onResume() {
        super.onResume()
        var accel: Sensor = sm.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        sm.registerListener(this,accel,SensorManager.SENSOR_DELAY_NORMAL)
    }

    override fun onPause() {
        super.onPause()
        sm.unregisterListener(this)
    }

    override fun onSensorChanged(event: SensorEvent?) {

        if (event != null) {
            sensorX.setText(valueOf(event.values[0]))
            sensorY.setText(valueOf(event.values[1]))
            sensorZ.setText(valueOf(event.values[2]))

        }
    }


}

