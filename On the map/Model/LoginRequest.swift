//
//  LoginRequest.swift
//  On the map
//
//  Created by Mac User on 5/6/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: LoginParameters
}
struct LoginParameters: Codable {
    let username: String
    let password: String
}
