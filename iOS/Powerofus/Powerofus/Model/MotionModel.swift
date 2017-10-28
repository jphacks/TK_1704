import CoreMotion

final class MotionModel {
    
    let motionManager = CMMotionManager()
    
    var accelerometerX = 0.0
    var accelerometerY = 0.0
    var accelerometerZ = 0.0
    
    var score = 0.0
    
    func startAccelerometer(){
        //使えるかどうか判定
        if motionManager.isAccelerometerAvailable {
            //0.1秒間隔で更新
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(
                to: OperationQueue.current!,
                withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                    self.outputData(acceleration: (accelData?.acceleration)!)
            })
        }
    }
    
    // センサー取得を止める場合
    func stopAccelerometer(){
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    func outputData(acceleration: CMAcceleration) {
        accelerometerX = acceleration.x
        accelerometerY = acceleration.y
        accelerometerZ = acceleration.z
        score += fabs(accelerometerX)
        print(score)
    }
}

