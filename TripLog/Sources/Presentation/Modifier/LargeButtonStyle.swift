//
//  LargeButtonStyle.swift
//  TripLog
//
//  Created by gnksbm on 9/23/24.
//

import SwiftUI

struct LargeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.tint)
            }
            .padding()
            .foregroundStyle(.white)
            .bold()
    }
}

#Preview {
    Button("테스트") {
        
    }
    .buttonStyle(LargeButtonStyle())
}
