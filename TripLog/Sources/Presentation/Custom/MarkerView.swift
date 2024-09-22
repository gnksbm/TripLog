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
            Path { path in
                path.addArc(
                    center: CGPoint(x: size / 2, y: size / 2),
                    radius: (size / 2) - borderWidth,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360),
                    clockwise: false
                )
            }
            .fill(Color.white)
        }
        .frame(width: size, height: size)
    }
    
    private var triangleView: some View {
        Path { path in
            // 삼각형의 상단시작 꼭짓점
            path.move(to: CGPoint(x: size / 2, y: 0))
            // 삼각형의 좌상단 꼭짓점
            path.addLine(
                to: CGPoint(
                    x: (size / 2) + (triangleSize / 2),
                    y: triangleSize
                )
            )
            // 삼각형을 우상단 꼭짓점
            path.addLine(
                to: CGPoint(
                    x: (size / 2) - (triangleSize / 2),
                    y: triangleSize
                )
            )
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
