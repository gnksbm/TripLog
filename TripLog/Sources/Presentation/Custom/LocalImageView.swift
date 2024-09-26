//
//  LocalImageView.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import SwiftUI

import Kingfisher

struct LocalImageView: View {
    let path: String?
    
    var body: some View {
        if let path {
            KFImage(FileManager.getLocalImageURL(additionalPath: path))
                .resizable()
                .scaledToFill()
                .clipped()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 1)
                )
        } else {
            Color.secondary.opacity(0.3)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.7))
                )
                .cornerRadius(12)
        }
    }
}

#Preview {
    LocalImageView(path: "")
}
