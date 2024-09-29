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
    
    static let skyBlueLight = Color(hex: "CAF0F8")
    static let skyBlueMedium = Color(hex: "ADE8F4")
    static let skyBlue = Color(hex: "90E0EF")
    static let oceanBlueLight = Color(hex: "48CAE4")
    static let oceanBlue = Color(hex: "00B4D8")
    static let deepBlue = Color(hex: "0096C7")
    static let royalBlue = Color(hex: "0077B6")
    static let navyBlue = Color(hex: "023E8A")
    static let midnightBlue = Color(hex: "03045E")
    
    static let primaryText = Color(hex: "03045E")
    static let secondaryText = Color(hex: "0077B6")
    
    static let successGreen = Color.green
    static let warningYellow = Color.yellow
    static let errorRed = Color.red
    
    static let backgroundGray = Color(UIColor.systemGray6)
    static let separatorGray = Color(UIColor.systemGray4)
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
