//
//  HexColor.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/21/24.
//

import Foundation
import SwiftUI

struct HColor {
    static func hsv(h: Int, s: Int, v: Int, a: Double = 1.0) -> Color {
        return Color(hue: Double(h) / 360.0, saturation: Double(s) / 100.0, brightness: Double(v) / 100.0, opacity: a)
    }
    static func rgb(r: Int, g: Int, b: Int, a: Double = 1.0) -> Color {
        return Color(red: Double(r) / 255.0, green: Double(g) / 255.0, blue: Double(b) / 255.0, opacity: a)
    }
}
