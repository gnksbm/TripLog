//
//  Image+.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import SwiftUI

extension Image {
    static let festival = if #available(iOS 17.0, *) {
        Image(systemName: "fireworks")
    } else {
        Image(systemName: "balloon.2")
    }
}
