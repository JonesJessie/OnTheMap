//
//  ClientError.swift
//  On the map
//
//  Created by Mac User on 5/6/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation

struct ClientError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
}
