//
//  Reservation.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/8/24.
//

import Foundation
import SwiftUI

class Reservation {
    var id: Int;
    var field: Int;
    var date: Date;
    var completed: Bool = false;
    // The following attributes are only needed for reservation view
    var courtID: Int;
    var resType: Int;
    var startTime: String;
    var endTime: String;
    // The following attributes are only needed for reservation management
    var userID: Int;
    init(id: Int, field: Int, date: String, courtID: Int = 0, resType: Int = 0, startTime: String = "", endTime: String = "", userID: Int = 0) {
        let dateFormatter = DateFormatter.yearMonthDay
        self.id = id
        self.field = field
        self.date = dateFormatter.date(from: date) ?? Date()
        self.courtID = courtID
        self.resType = resType
        self.startTime = startTime
        self.endTime = endTime
        self.userID = userID
    }
    
}
