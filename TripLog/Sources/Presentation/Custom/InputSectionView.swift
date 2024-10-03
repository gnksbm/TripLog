//
//  InputSectionView.swift
//  TripLog
//
//  Created by gnksbm on 10/3/24.
//

import SwiftUI

struct InputSectionView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(TLFont.headline)
                .fontWeight(.black)
                .foregroundColor(TLColor.primaryText)
            content()
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(TLColor.skyBlueLight.opacity(0.2))
                )
        }
    }
}

#Preview {
    InputSectionView(title: "테스트") {
        Text("")
    }
}
