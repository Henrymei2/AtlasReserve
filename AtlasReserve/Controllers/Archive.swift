//
//  Archive.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/20/24.
//
import Foundation

class Archive: Identifiable {
    var resID: Int = 0;
    var userID: Int = 0;
    var courtID: Int = 0;
    var fieldID: Int = 0;
    var date: Date = Date();
    var state: Int = 0;
    var reason: String = "";
    init(resID: Int,userID: Int, courtID: Int, fieldID: Int, date: String, state: Int, reason: String = "") {
        self.resID = resID
        self.userID = userID
        self.courtID = courtID
        self.fieldID = fieldID
        self.date = DateFormatter.yearMonthDay.date(from: date) ?? Date()
        self.state = state
        self.reason = reason
    }
}
