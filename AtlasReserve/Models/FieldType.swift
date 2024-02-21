//
//  FieldType.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/13/24.
//

import Foundation

struct FieldType {
    static let types: [Int] = [1, 2, 3, 4, 5]
    static let convert: Dictionary = [
        1: "3v3",
        2: "5v5",
        3: "7v7",
        4: "9v9",
        5: "11v11"
    ]
    static let maxType = 5
}
