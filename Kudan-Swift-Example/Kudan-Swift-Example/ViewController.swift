//
//  ViewController.swift
//  Kudan-Swift-Example
//
//  Created by Nicolas Hinderling on 4/3/17.
//  Copyright © 2017 Nicolas Hinderling. All rights reserved.
//

import KudanAR

enum ArbiTrackState {
    case ARBI_PLACEMENT
    case ARBI_TRACKING
}

//func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
//    objc_sync_enter(lock)
//    defer { objc_sync_exit(lock) }
//    return try body()
//}

class ViewController: ARCameraViewController {
    // NICO - Look into using lazy for some of these vars
    var modelNode = ARModelNode()
    
    var arbiButtonState: ArbiTrackState = .ARBI_PLACEMENT
    var lastScale: Float = 0
    var lastPanX: Float = 0
    
    override func setupContent() {
        setupModel()
        setupArbiTrack()
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(arbiPinch))
        self.cameraView.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(arbiPan))
        self.cameraView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(arbiTap))
        self.cameraView.addGestureRecognizer(tapGesture)
    }
    
    func setupModel() {
        let importer: ARModelImporter = ARModelImporter(bundled: "footballer_dancing.armodel")
        
        // Get a node representing the model's contents.
        let model: ARModelNode = importer.getNode()
        
        model.start()
        model.shouldLoop = true
        model.scale(byUniform: 10)
        
        // Set up and add the model material.
        let modelTexture: ARTexture = ARTexture(uiImage: UIImage(named:"footballer_tex.png"))
        let modelMaterial = ARLightMaterial()
        
        modelMaterial.colour.texture = modelTexture
        modelMaterial.diffuse.value = ARVector3(valuesX: 1, y: 1, z: 1)
        modelMaterial.ambient.value = ARVector3(valuesX: 0.5, y: 0.5, z: 0.5)

        guard let meshNodes: [ARMeshNode] = model.meshNodes as? [ARMeshNode] else {
            print("setupModel: Error when trying to access model meshNodes")
            return
        }

        for meshNode in meshNodes {
            meshNode.material = modelMaterial
        }
        
        self.modelNode = model
    }

    func setupArbiTrack() {
        // Initialise gyro placement. Gyro placement positions content on a virtual floor plane where the device is aiming.
        let gyroPlaceManager = ARGyroPlaceManager()
        gyroPlaceManager.initialise()
        
        // Set up the target node on which the model is placed.
        let targetNode: ARNode = ARNode(name: "targetNode")
        gyroPlaceManager.world.addChild(targetNode)
        
        // Add a visual reticule to the target node for the user.
        let targetImageNode: ARImageNode = ARImageNode(image: UIImage(named: "target.png"))
        targetNode.addChild(targetImageNode)
        
        // Scale and rotate the image to the correct transformation.
        targetImageNode.scale(byUniform: 0.1)
        targetImageNode.rotate(byDegrees: 90, axisX: 1, y: 0, z: 0)
        
        // Initialise the arbiTracker, do not start until user placement.
        let arbiTrack = ARArbiTrackerManager()
        arbiTrack.initialise()
        
        // Set the arbiTracker target node to the node moved by the user.
        arbiTrack.targetNode = targetNode
        arbiTrack.world.addChild(modelNode)
    }

    func arbiTap(gesture: UITapGestureRecognizer) {
        print("tap!")
        
        let arbiTrack = ARArbiTrackerManager()
        
        if(arbiButtonState == .ARBI_PLACEMENT) {
            arbiTrack.start()
            arbiTrack.targetNode.visible = false
            
            self.modelNode.scale = ARVector3(valuesX: 1, y: 1, z: 1)
            arbiButtonState = .ARBI_TRACKING
            return
            
        } else if (arbiButtonState == .ARBI_TRACKING) {
            arbiTrack.stop()
            arbiTrack.targetNode.visible = true
            arbiButtonState = .ARBI_PLACEMENT
        }
    }
    
    func arbiPinch(gesture: UIPinchGestureRecognizer) {
        print("pinch!")
        
        var scaleFactor = Float(gesture.scale)

        if(gesture.state == .began) {
            lastScale = 1
        }
        
        scaleFactor = 1 - (lastScale - scaleFactor)
        lastScale = Float(gesture.scale)
        
//        synchronized(modelNode, self.modelNode.scale(byUniform: scaleFactor))
        self.modelNode.scale(byUniform: scaleFactor)
    }
    
    func arbiPan(gesture: UIPanGestureRecognizer) {
        print("pan!")
        
        let x = Float(gesture.translation(in: self.cameraView).x)
        
        if(gesture.state == .began) {
            lastPanX = x
        }
        
        let diff = x - lastPanX
        let deg = diff * 0.5
        
//        synchronized(modelNode, self.modelNode.rotate(byDegrees: deg, axisX: 0, y: 1, z: 0))
        self.modelNode.rotate(byDegrees: deg, axisX: 0, y: 1, z: 0)
    }
}

