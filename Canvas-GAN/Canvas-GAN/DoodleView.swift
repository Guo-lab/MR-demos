//
//  DoodleView.swift
//  Canvas-GAN
//
//  Created by Guo Siqi on 11/18/23.
//

import Foundation
import SwiftUI
import UIKit

struct DoodleView: View {
    @Environment(ViewModel.self) private var viewModel
    @Environment(\.dismissWindow) private var dismissWindow
    
    var convertView: some View { return VStack { DrawingView() } }
    
    var body: some View {
        VStack {
            DrawingView()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(15)
                .padding()
            
            Button("Done") {
                // @https://developer.apple.com/videos/play/wwdc2023/111215/?time=176
                // @https://clipdrop.co/apis/docs/sketch-to-image
                // Pity that trapped here,
                // Back if possible
                let image = UIImage(named: "think_different")
                if image == nil { print("No") }
                
                let renderer = ImageRenderer(content: body)
                if let img = renderer.uiImage {
                    let filename_2 = NSHomeDirectory() + "/doodle.png"
                    print(type(of: img))
                    try? img.pngData()?.write(to: URL(fileURLWithPath: filename_2))
                }
                
                dismissWindow(id: "doodle_canvas")
                viewModel.flowState = .PROJECTILEFLYING
            }
            Spacer()
        }
    }
}


/* create interoperability between SwiftUI and UIKit */
struct DrawingView: UIViewRepresentable {
    func makeUIView(context: Context) -> DrawingUIView {
        let view = DrawingUIView()
        return view
    }
    func updateUIView(_ uiView: DrawingUIView, context: Context) {}
}


//extension UIView {
//}

/* UIView in UIKit */
class DrawingUIView: UIView {
    private var path = UIBezierPath()
    private var strokeWidth: CGFloat = 5.0
    private var width_drawing = 0.0
    private var height_drawing = 0.0
    
    // ======== Init ========
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        path.lineWidth = strokeWidth
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        width_drawing = CGRectGetWidth(rect)
        height_drawing = CGRectGetHeight(rect)
        UIColor.black.setStroke()
        path.stroke()
    }
    
    // ======== Touches ========
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        path.move(to: touch.location(in: self))
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        path.addLine(to: touch.location(in: self))
        setNeedsDisplay()
    }
//    func asImage(backgroundColor: UIColor = .white, strokeColor: UIColor = .black) -> UIImage? {
//        let size = CGSize(width: width_drawing, height: height_drawing)
//        let renderer = UIGraphicsImageRenderer(size: size)
//        let image = renderer.image { ctx in
//            backgroundColor.setFill()
//            strokeColor.setStroke()
//            path.stroke()
//        }
//        return image
//    }
}
