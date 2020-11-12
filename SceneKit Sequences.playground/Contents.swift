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

let actionDuration: TimeInterval = 3

func addBox(positon: SCNVector3) ->SCNNode {
    let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.0)
    let boxNode = SCNNode(geometry: box)
    boxNode.position = positon
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
func addBox2(positon: SCNVector3, duration: TimeInterval) -> SCNNode {
    let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.0)
    let boxNode = SCNNode(geometry: box)
    boxNode.position = positon
    box.firstMaterial?.diffuse.contents  = UIColor.yellow
    box.firstMaterial?.specular.contents = UIColor.orange
    let action = SCNAction.moveBy(x: 0, y: -3, z: 0, duration: duration)
    let rotate = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(-1, 0, 1), duration: duration))
    let group = SCNAction.group([action, rotate])

    let blockAction = SCNAction.run { (node) in
        print("sequence is over")
    }

    let sequence = SCNAction.sequence([group, blockAction, SCNAction.removeFromParentNode()])
    boxNode.runAction(sequence)

    return boxNode
}


// Add a 3rd box
func addBox3(positon: SCNVector3, duration: TimeInterval) -> SCNNode {
    let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.0)
    let boxNode = SCNNode(geometry: box)
    boxNode.position = positon
    scene.rootNode.addChildNode(boxNode)
    box.firstMaterial?.diffuse.contents  = UIColor.green
    box.firstMaterial?.specular.contents = UIColor.blue
    let moveAction = randomizedMovementAction(duration: duration)

    let rotate = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(1, 0, 1), duration: duration))
    let group = SCNAction.group([moveAction, rotate])

    let sequenceOne = SCNAction.sequence([group])
    let end = endAction()
    let sequence = SCNAction.sequence([sequenceOne, end])

    boxNode.runAction(sequence)

    return boxNode
}

// spin fast while scaling down to a very small size
func endAction()  -> SCNAction {
    let duration: TimeInterval = 0.25
    let scale = SCNAction.scale(to: 0.01, duration: duration)
    //let rotate = SCNAction.rotate(by: .pi, around: SCNVector3(0, 0, 1), duration: duration)
    //let group = SCNAction.group([scale, rotate])
    return scale
}

// create a sequence of actions with randomized movement
func randomizedMovementAction (duration: TimeInterval) -> SCNAction {

    // create 4 sequences adding up the input duration
    var modifiedDuration:Float = Float(duration)

    let r1 = Float.random(in: 0.5 ..< modifiedDuration)

    modifiedDuration = modifiedDuration - r1
    if (modifiedDuration < 0.5) {
        modifiedDuration = 0.51
    }
    let r2 = Float.random(in: 0.5 ..< modifiedDuration)

    modifiedDuration = modifiedDuration - r2
    if (modifiedDuration < 0.5) {
        modifiedDuration = 0.51
    }
    let r3 = Float.random(in: 0.5 ..< modifiedDuration)

    modifiedDuration = modifiedDuration - r3
    if (modifiedDuration < 0.5) {
        modifiedDuration = 0.51
    }
    let r4 = Float.random(in: 0.5 ..< modifiedDuration)

    let xDrift1 = CGFloat.random(in: 0.5 ..< 1.0)
    let y1: CGFloat = -3.0 / 4.0
    let action1 = SCNAction.moveBy(x: xDrift1, y: y1, z: 0, duration: TimeInterval(r1))

    let xDrift2 = -CGFloat.random(in: 0.5 ..< 1.0)
    let y2: CGFloat = -3.0 / 4.0
    let action2 = SCNAction.moveBy(x: xDrift2, y: y2, z: 0, duration: TimeInterval(r2))

    let xDrift3 = CGFloat.random(in: 0.5 ..< 1.0)
    let y3: CGFloat = -3.0 / 4.0
    let action3 = SCNAction.moveBy(x: xDrift3, y: y3, z: 0, duration: TimeInterval(r3))

    let xDrift4 = -CGFloat.random(in: 0.5 ..< 1.0)
    let y4: CGFloat = -3.0 / 4.0
    let action4 = SCNAction.moveBy(x: xDrift4, y: y4, z: 0, duration: TimeInterval(r4))

    let action = SCNAction.sequence([action1, action2, action3, action4])
    return action
}


// Add a box primitive to the playground
let node = addBox(positon: SCNVector3(-2, 1.5, 0))
scene.rootNode.addChildNode(node)

let nodeB = addBox2(positon: SCNVector3(2, 1.5, 0), duration: actionDuration)
scene.rootNode.addChildNode(nodeB)

let nodeC = addBox3(positon: SCNVector3(0, 1.5, 0), duration: actionDuration)
scene.rootNode.addChildNode(nodeC)
