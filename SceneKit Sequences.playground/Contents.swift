import PlaygroundSupport
import UIKit
import SceneKit
import QuartzCore

// Set up a scene view
var sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
var scene = SCNScene()
sceneView.scene = scene
sceneView.backgroundColor = .black
PlaygroundPage.current.liveView = sceneView

// Add some lighting
var lightNode = SCNNode()
lightNode.light = SCNLight()
lightNode.light?.type = .directional
lightNode.light?.intensity = 3000
lightNode.light?.shadowMode = .deferred
lightNode.rotation = SCNVector4(x: 0, y: 0, z: 0.5, w: 1.5 * Float.pi)
scene.rootNode.addChildNode(lightNode)

// Camera
var cameraNode = SCNNode()
cameraNode.camera = SCNCamera()
cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
scene.rootNode.addChildNode(cameraNode)

func addBox() ->SCNNode {
    let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.0)
    let boxNode = SCNNode(geometry: box)
    boxNode.position = SCNVector3(-2, 1.5, 0)
    box.firstMaterial?.diffuse.contents  = UIColor.gray
    box.firstMaterial?.specular.contents = UIColor.darkGray
    boxNode.rotation = SCNVector4(x: 1.0, y: 1.0, z: 0.0, w: 0.0)
    let spin = CABasicAnimation(keyPath: "rotation.w")
    spin.toValue = 3 * -CGFloat.pi
    spin.duration = 2
    spin.repeatCount = .greatestFiniteMagnitude
    boxNode.addAnimation(spin, forKey: "spin around")

    return boxNode
}

// Add a 2nd box
func addBox2() -> SCNNode {
    let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.0)
    let boxNode = SCNNode(geometry: box)
    boxNode.position = SCNVector3(0, 1.5, 0)
    box.firstMaterial?.diffuse.contents  = UIColor.yellow
    box.firstMaterial?.specular.contents = UIColor.orange
    boxNode.rotation = SCNVector4(x: 1.0, y: 1.0, z: 0.0, w: 0.0)
    let fadeInAction = SCNAction.fadeIn(duration: 2.0)
    let fadeOutAction = SCNAction.fadeOut(duration: 1.5)
    let action = SCNAction.moveBy(x: 0, y: -2, z: 0, duration: 3)
    let rotate = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0, 0, 1), duration: 3))
    let group = SCNAction.group([action, rotate])

    let blockAction = SCNAction.run { (node) in
        print("sequence is over")
    }

    let sequence = SCNAction.sequence([fadeInAction, group, fadeOutAction,blockAction, SCNAction.removeFromParentNode()])
    boxNode.runAction(sequence)

    return boxNode
}


// Add a 3rd box
func addBox3() -> SCNNode {
    let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.0)
    let boxNode = SCNNode(geometry: box)
    boxNode.position = SCNVector3(1, 1.5, 0)
    scene.rootNode.addChildNode(boxNode)
    box.firstMaterial?.diffuse.contents  = UIColor.green
    box.firstMaterial?.specular.contents = UIColor.blue
    boxNode.rotation = SCNVector4(x: -1.0, y: 1.0, z: 0.0, w: 0.0)
    let fadeInAction = SCNAction.fadeIn(duration: 2.0)
    let fadeOutAction = SCNAction.fadeOut(duration: 1.5)
    let action = SCNAction.moveBy(x: 0, y: -2, z: 0, duration: 3)
    let rotate = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0, 0, 1), duration: 3))
    let group = SCNAction.group([action, rotate])

    let blockAction = SCNAction.run { (node) in
        print("sequence is over")
    }

    let sequence = SCNAction.sequence([fadeInAction, group, fadeOutAction,blockAction, SCNAction.removeFromParentNode()])

    boxNode.runAction(sequence)

    return boxNode
}


// Add a box primitive to the playground
let node = addBox()
scene.rootNode.addChildNode(node)

let nodeB = addBox2()
scene.rootNode.addChildNode(nodeB)

let nodeC = addBox3()
scene.rootNode.addChildNode(nodeC)
