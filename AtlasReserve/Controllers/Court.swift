//
//  Court.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 8/20/23.
//

import Foundation
import SwiftUI
import Kingfisher

class Court: Identifiable, ObservableObject {
    
    var id: Int = 0;
    var name: String = "";
    var owner: String = "";
    var address: String = "";
    var courtNumber: Int = 0;
    var previewImage: UIImage;
    // This attribute is only useful for OwnerControlView
    var ownerID: Int;
    // This attribute is useful for image loading
    var previewImageURL: URL;
    init(id: Int, name: String, owner: String, address: String, courtNumber: Int, previewImageURL: URL, ownerID: Int = 0) {
        self.id = id
        self.name = name
        self.owner = owner
        self.address = address
        self.courtNumber = courtNumber
        self.previewImageURL = previewImageURL
        self.previewImage = UIImage(systemName: "folder")!
        self.ownerID = ownerID
    }
    
}
