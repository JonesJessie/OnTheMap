//
//  LoginResponse.swift
//  On the map
//
//  Created by Mac User on 5/4/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
