//
//  User.swift
//  On the map
//
//  Created by Mac User on 5/4/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
}
