//
//  ViewController.swift
//  ARMeasuring
//
//  Created by Martin Saporiti on 02/06/2018.
//  Copyright © 2018 Martin Saporiti. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                       ARSCNDebugOptions.showWorldOrigin]
        
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration);
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    
    //
    @objc func handleTap(sender: UITapGestureRecognizer){
        
        guard let sceneView = sender.view as? ARSCNView else {return}
        guard let currentFrame = sceneView.session.currentFrame else {return}
        let camera = currentFrame.camera
        
        let transform = camera.transform
        
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        sphere.simdTransform = transform
        sceneView.scene.rootNode.addChildNode(sphere)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

