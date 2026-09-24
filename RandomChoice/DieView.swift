//
//  Die.swift
//  RandomChoice
//
//  Created by Wesley Chastain on 11/25/24.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform { ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * shakesPerUnit), y: 0))
    }
}

struct PointedBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let cornerRadius: CGFloat = 10
        let pointerSize: CGFloat = 20
        
        // Create the main rounded rectangle
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height - pointerSize), cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        // Add the pointer
        path.move(to: CGPoint(x: rect.width / 2 - 3 - pointerSize / 2, y: rect.height - pointerSize + 5))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width / 2 + 3 + pointerSize / 2, y: rect.height - pointerSize + 5))
        
        return path
    }
}


struct DieView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var number = 0
    @State var rotation: Double = 0
    @State var swipeUp: Int = 0
    @State var numRotate = 0
    @State var hideInstructions: Bool = false
    @State private var shakes: CGFloat = 0
    @State var bounce = false
    @EnvironmentObject var random: RotationViewModel
    
    var body: some View {
        VStack {
            
            // hideInstructions is set to false when the Xcode image asset is tapped
            if !hideInstructions {
                // if the boolean hideInstructions is false then show the instructions
                Text("Tap to Roll")
                    .font(.title2)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .padding()
                    .offset(y: -10)
                    .frame(width: 140, height: 70)
                    .background(PointedBubble().fill(Color.blue))
                    .overlay(PointedBubble().stroke(Color.blue, lineWidth: 2))
                    .offset(y: bounce ? 10 : 20)
                    .animation( // Up and down animation to make the text move with the shape
                        Animation
                            .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true),
                        value: bounce
                    )
                    .onAppear {
                        bounce = true
                    }
                    .onTapGesture {
                        withAnimation {
                            hideInstructions = true
                        }
                    }
            }
            
            
            
            
            
            ZStack {

                VStack {

                    // change the Xcode image asset to the black image or the white one depending on the setting on the iPhone that sets the colorScheme
                    if colorScheme == .light {
                        Image(number == 1 ? "1l" : number == 2 ? "2l" : number == 3 ? "3l" : number == 4 ? "4l" : number == 5 ? "5l" : number == 6 ? "6l" : "?l")
                            .resizable()
                            .frame(width: 170, height: 150)
                    }
                    else {
                        Image(number == 1 ? "1d" : number == 2 ? "2d" : number == 3 ? "3d" : number == 4 ? "4d" : number == 5 ? "5d" : number == 6 ? "6d" : "?d")
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                    
                    
                }
            }
            .onTapGesture {
                hideInstructions = true
                
                withAnimation {
                    self.shakes += CGFloat(Int.random(in: 1...3)) // Trigger the shake animation
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                {
                    withAnimation
                    {
                        number = Int.random(in: 1...6) // grab a random integer from 1 to 6
                        rotation += Double(360*Double.random(in: 0.5...2)) // create a random rotation value for the rotation animation
                        numRotate += 360*Int.random(in: 1...3)
                    }
                }
            }
            .font(.largeTitle)
            .modifier(ShakeEffect(animatableData: shakes))
            .rotationEffect(Angle(degrees: rotation))
            .animation(.easeInOut(duration: 1), value: rotation)
            .padding()
            
        }
        
    }
}

#Preview {
    DieView()
        .environmentObject(RotationViewModel())
}
