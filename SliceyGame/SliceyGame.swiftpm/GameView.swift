import SwiftUI
import SpriteKit

struct GameView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let sceneView = SKView(frame: UIScreen.main.bounds)
        let scene = GameScene(size: sceneView.bounds.size)
        scene.scaleMode = .aspectFit
        sceneView.presentScene(scene)
        sceneView.showsPhysics = true
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        return sceneView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {}
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}


