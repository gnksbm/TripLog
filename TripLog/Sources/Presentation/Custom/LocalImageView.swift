//
//  LocalImageView.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import SwiftUI

struct LocalImageView: View {
    let path: String?
    
    var body: some View {
        if let path {
            AsyncImage(
                url: FileManager.getLocalImageURL(
                    additionalPath: path
                )
            ) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(_):
                    Color.secondary
                @unknown default:
                    Color.secondary
                }
            }
        } else {
            Color.secondary
        }
    }
}
