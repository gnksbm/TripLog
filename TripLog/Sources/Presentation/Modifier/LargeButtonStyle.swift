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
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .clipped()
            .background(.tint)
            .padding()
    }
}
