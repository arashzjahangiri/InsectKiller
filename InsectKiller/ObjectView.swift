//
//  ObjectView.swift
//  InsectKiller
//
//  Created by Arash ZandJahangiri on 20/02/2024.
//

import SwiftUI

struct Object: Identifiable {
    var id = UUID()
    var position: CGPoint
    var size: CGSize
}

struct ObjectView: View, Identifiable {
    var id: UUID

    let object: Object

    var body: some View {
        Image(randomInsect())
            .resizable()
            .foregroundColor(randomColor())
            .frame(width: object.size.width, height: object.size.height)
            .position(object.position)
    }

    private func randomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }

    private func randomShape() -> String {
        let shapes: [String] = [
            "circle.fill", "square.fill", "triangle.fill", "heart.fill", "star.fill",
            "rectangle.fill", "capsule.fill", "cube.fill", "sphere.fill", "pyramid.fill"
        ]
        return shapes[Int.random(in: 0...shapes.count - 1)]
    }

    private func randomInsect() -> String {
        return "insect_\(Int.random(in: 1...8))"
    }
}
