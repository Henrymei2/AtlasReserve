//
//  User.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 2/18/24.
//

import Foundation

class User: Identifiable {
    var id: Int = 0;
    var username: String = "";
    var telephone: String = "";
    init(id: Int, username: String, telephone: String) {
        self.id = id
        self.username = username
        self.telephone = telephone
    }
}
