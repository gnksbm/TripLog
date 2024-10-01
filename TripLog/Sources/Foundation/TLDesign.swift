//
//  TLDesign.swift
//  TripLog
//
//  Created by gnksbm on 9/26/24.
//

import SwiftUI

enum TLFont {
    static let headline = Font.custom("NanumSquareOTFB", size: 22)
    static let subHeadline = Font.custom("NanumSquareOTFEB", size: 20)
    static let body = Font.custom("NanumSquareOTFR", size: 16)
    static let caption = Font.custom("NanumSquareOTFL", size: 12)
    static let accent = Font.custom("NanumSquareOTFR", size: 18)
}

enum TLColor {
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
    
    static let successGreen = Color(hex: "4CAF50")
    static let warningYellow = Color(hex: "FFC107")
    static let errorRed = Color(hex: "F44336")
    
    static let backgroundGray = Color(hex: "F7F7F7")
    static let separatorGray = Color(hex: "E0E0E0")
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
