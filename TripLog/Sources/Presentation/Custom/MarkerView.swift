//
//  MarkerView.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import SwiftUI

struct MarkerView: View {
    let color: Color
    let size: CGFloat
    let borderWidth: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            circleView
            triangleView
        }
    }
    
    private var circleView: some View {
        ZStack {
            Circle()
                .fill(color)
            Circle()
                .stroke(Color.white, lineWidth: borderWidth)
            Circle()
                .fill(Color.white)
                .frame(width: size / 2, height: size / 2)
        }
        .frame(width: size, height: size)
    }
    
    private var triangleView: some View {
        Path { path in
            path.move(to: CGPoint(x: size / 2, y: 0))
            path.addLine(to: CGPoint(x: (size / 2) + (triangleSize / 2), y: triangleSize))
            path.addLine(to: CGPoint(x: (size / 2) - (triangleSize / 2), y: triangleSize))
            path.closeSubpath()
        }
        .fill(color)
        .frame(width: size, height: triangleSize)
        .rotationEffect(Angle(degrees: 180))
        .offset(y: -borderWidth)
        .padding(.bottom, 40)
    }
    
    private var triangleSize: CGFloat {
        size / 3
    }
    
    init(
        color: Color = .accentColor,
        size: CGFloat = 42,
        borderWidth: CGFloat? = nil
    ) {
        self.color = color
        self.size = size
        self.borderWidth = borderWidth ?? size / 8
    }
}

#Preview {
    VStack {
        Spacer()
        MarkerView(size: 300)
        Spacer()
    }
}
