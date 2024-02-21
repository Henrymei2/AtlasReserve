//
//  DayOfWeek.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/5/24.
//

import Foundation
import SwiftUI

struct DayOfWeek {
    static func convert(from dayNumber: Int) -> String {
        let rst: String
        switch dayNumber {
        case 0: rst = "Monday"
        case 1: rst = "Tuesday"
        case 2: rst = "Wednesday"
        case 3: rst = "Thursday"
        case 4: rst = "Friday"
        case 5: rst = "Saturday"
        case 6: rst = "Sunday"
        default: rst = "Error"
        }
        return rst
    }
}
