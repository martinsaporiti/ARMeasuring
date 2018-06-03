//
//  ViewController.swift
//  ARMeasuring
//
//  Created by Martin Saporiti on 02/06/2018.
//  Copyright © 2018 Martin Saporiti. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate{

    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    var startingPosition: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                       ARSCNDebugOptions.showWorldOrigin]
        
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration);
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        self.xLabel.alpha = 0.5
        self.yLabel.alpha = 0.5
        self.zLabel.alpha = 0.5
        self.distanceLabel.alpha = 0.5
        
        self.sceneView.delegate = self
    }
    
    
    
    //
    @objc func handleTap(sender: UITapGestureRecognizer){
        
        guard let sceneView = sender.view as? ARSCNView else {return}
        guard let currentFrame = sceneView.session.currentFrame else {return}
        let camera = currentFrame.camera
        
        if startingPosition != nil {
            self.startingPosition?.removeFromParentNode()
            self.startingPosition = nil
            return
        }
        
        let transform = camera.transform
        print("transform: " , transform)
        print("transform z", transform.columns.3.z)
        
        // Lo siguiente aleja -0.1 metros la posición para la colocación de la esfera.
        var translationMatrix =  matrix_identity_float4x4
        
        translationMatrix.columns.3.z = -0.1
        
        let modifiedMatrix = simd_mul(transform, translationMatrix)
        
        print("modifiedMatrix: " , modifiedMatrix)
        print("modifiedMatrix z", modifiedMatrix.columns.3.z)
        
        print("modifiedMatrix z - transform z: ",  modifiedMatrix.columns.3.z - transform.columns.3.z)
        
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        sphere.simdTransform = modifiedMatrix
        sceneView.scene.rootNode.addChildNode(sphere)
        self.startingPosition = sphere
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // La siguiente función se ejecuta a 60 fotogramas por segundo
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let startingPosition = self.startingPosition else {return}
        
        guard let pointOfView = self.sceneView.pointOfView else {return}
        
        let transform = pointOfView.transform
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)

        let xDistance = location.x - startingPosition.position.x
        let yDistance = location.y - startingPosition.position.y
        let zDistance = location.z - startingPosition.position.z
        
        DispatchQueue.main.async {
            self.xLabel.text = String(format: "%.2f", xDistance) + "m"
            self.yLabel.text = String(format: "%.2f", yDistance) + "m"
            self.zLabel.text = String(format: "%.2f", zDistance) + "m"
            self.distanceLabel.text = String(format: "%.2f", self.distance(x: xDistance, y: yDistance, z: zDistance)) + "m"
        }


    }

    
    func distance(x: Float, y: Float, z: Float) -> Float {
        return (sqrtf(x*x + y*y + z*z))
    }

}

