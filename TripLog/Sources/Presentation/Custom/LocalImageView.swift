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
            KFImage(
                FileManager.getLocalImageURL(
                    additionalPath: path
                )
            )
            .resizable()
            .scaledToFill()
        } else {
            Color.secondary
        }
    }
}

#Preview {
    LocalImageView(path: "")
}
