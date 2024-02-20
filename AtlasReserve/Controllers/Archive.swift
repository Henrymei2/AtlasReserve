//
//  Archive.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/20/24.
//
import Foundation

class Archive: Identifiable {
    var userID: Int = 0;
    var courtID: Int = 0;
    var fieldID: Int = 0;
    var date: Date = Date();
    var type: Int = 0;
    init(userID: Int, courtID: Int, fieldID: Int, type: Int) {
        self.userID = userID
        self.courtID = courtID
        self.fieldID = fieldID
        self.type = type
    }
}
