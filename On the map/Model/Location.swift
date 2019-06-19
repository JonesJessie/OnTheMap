//
//  Location.swift
//  On the map
//
//  Created by Mac User on 5/1/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

struct Location: Codable {
    
    var objectId: String
    var uniqueKey: String?
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longtitude: Double
    var createdAt: String
    var updatedAt: Date
}
