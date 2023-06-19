//
//  ColorExtension.swift
//  DAIL_E
//
//  Created by Park on 2023/05/28.
//

import SwiftUI

extension Color {
    static let mainColor = Color(hex: "00C77F")
    static let lightGray = Color(hex: "EDEDED")
    static let midGray = Color(hex: "B0B0B0")
    static let invalidRed = Color(hex: "FF7D7D")
}
 
extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}
