//
//  StudentInformation.swift
//  On the map
//
//  Created by Mac User on 5/5/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let objectId: String
    let mediaURL: String
    let firstName: String
    let longitude: Double
    let uniqueKey: String
    let latitude: Double
    let mapString: String
    let lastName: String
    
    var name: String {
        get {
            return firstName + " " + lastName //store init
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.objectId = try container.decodeIfPresent(String.self, forKey: .objectId) ?? ""
        self.mediaURL = try container.decodeIfPresent(String.self, forKey: .mediaURL) ?? ""
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        self.uniqueKey = try container.decodeIfPresent(String.self, forKey: .uniqueKey) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        self.mapString = try container.decodeIfPresent(String.self, forKey: .mapString) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
    }
    
    init(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, objectId: String ) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.objectId = objectId
    }
}
