//
//  TLDesign.swift
//  TripLog
//
//  Created by gnksbm on 9/26/24.
//

import SwiftUI

enum TLFont {
    static let headline = Font.custom("NanumSquareOTF_acB", size: 22)
    static let subHeadline = Font.custom("NanumSquareOTF_acEB", size: 20)
    static let body = Font.custom("NanumSquareOTFR", size: 16)
    static let caption = Font.custom("NanumSquareOTFL", size: 12)
    static let accent = Font.custom("NanumSquareOTF_acR", size: 18)
}

enum TLColor {
    static let coralOrange = Color.coralOrange
    static let lightPeach = Color.lightPeach
    static let royalBlue = Color.royalBlue
    static let backgroundGray = Color.backgroundGray
    static let separatorGray = Color.separatorGray
    
    static let primaryText = Color.primaryText
    static let secondaryText = Color.secondaryText
    
    static let successGreen = Color.successGreen
    static let warningYellow = Color.warningYellow
    static let errorRed = Color.errorRed
}
