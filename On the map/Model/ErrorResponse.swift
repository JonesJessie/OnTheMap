//
//  ErrorResponse.swift
//  On the map
//
//  Created by Mac User on 5/4/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
}
