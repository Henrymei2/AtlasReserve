//
//  Field.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/2/24.
//

import Foundation
import SwiftUI

class Field {
    var id: Int = 0;
    var type: Int = 0;
    var startTime: Date = Date();
    var endTime: Date = Date();
    var availability: Int;
    var isAvailableNow: Bool = false;
    var count: Int = 1;
    var courtID: Int = 0;
    var availabilityArray: [Bool]; // This attribute is used for Court Management
    init(id: Int, type: Int, startTime: String, endTime: String, availability: Int, count: Int, availabilityArray: [Bool] = [false, false, false, false, false, false, false], courtID: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        self.id = id
        self.courtID = courtID
        self.type = type
        self.startTime = dateFormatter.date(from: startTime) ?? Date()
        self.endTime = dateFormatter.date(from: endTime) ?? Date()
        self.availability = availability
        self.availabilityArray = availabilityArray
        self.count = count
    }
    
}
