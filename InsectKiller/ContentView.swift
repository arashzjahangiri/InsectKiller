//
//  ContentView.swift
//  InsectKiller
//
//  Created by Arash ZandJahangiri on 20/02/2024.
//

import SwiftUI
import CoreGraphics

struct ContentView: View {
    private struct Constants {
        static let minTimer = 0.2
        static let maxTimer = 1.5
        static let gameThreshold = 5
    }
    @State private var score: Int = 0
    @State private var objectViews: [ObjectView] = []
    @State private var showingDialog = false
    @State private var timer = Timer.publish(
        every: Double.random(in: Constants.minTimer...Constants.maxTimer),
        on: .main,
        in: .common
    )
        .autoconnect()

    var body: some View {
        Text("Your Score:\(score)")
            .bold()
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)

                ForEach(objectViews) { view in
                    view
                        .onTapGesture {
                            destroy(object: view)
                        }
                }
            }
            .alert(isPresented: $showingDialog) {
                Alert(
                    title: Text("You lost!!!"),
                    message: Text("Too many insects. More than \(Constants.gameThreshold)"),
                    primaryButton: .default(Text("Try again")) {
                        tryAgain()
                    },
                    secondaryButton: .destructive(Text("I don't want to play anymore! Close the app.")) {
                        exit(0)
                    })
            }
            .onReceive(timer) { _ in
                addRandomObject(frame: geometry.size)
            }
        }
    }

    private func addRandomObject(frame: CGSize) {
        let size = randomSize()
        let position = randomPoint(inFrame: frame, objectSize: size)
        let randomObject = Object(
            position: position,
            size: size
        )
        let objectView = ObjectView(id: UUID(), object: randomObject)
        objectViews.append(objectView)
        if objectViews.count > Constants.gameThreshold {
            showLoseDialog()
        }
    }

    private func showLoseDialog() {
        showingDialog = true
        stopTimer()
    }

    private func tryAgain() {
        score = 0
        objectViews.removeAll()
        startTimer()
    }

    private func startTimer() {
        self.timer = Timer.publish(
            every: Double.random(in: Constants.minTimer...Constants.maxTimer),
            on: .main,
            in: .common
        )
        .autoconnect()
    }

    private func stopTimer() {
        self.timer.upstream.connect().cancel()
    }

    private func destroy(object: ObjectView) {
        if let index = objectViews.firstIndex(where: { $0.object.id == object.object.id }) {
            objectViews.remove(at: index)
            score += 1
        }
    }

    private func randomPoint(inFrame: CGSize, objectSize: CGSize) -> CGPoint {
        return CGPoint(
            x: CGFloat.random(in:100...inFrame.width - objectSize.width),
            y: CGFloat.random(in: 100...inFrame.height - objectSize.height)
        )
    }

    private func randomSize() -> CGSize {
        let randomNumber = Int.random(in: 100...300)
        return CGSize(width: randomNumber, height: randomNumber)
    }
}
