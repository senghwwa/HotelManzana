//
//  RoomType.swift
//  HotelManzana
//
//  Created by Seng Hwwa on 11/01/2019.
//  Copyright © 2019 senghwabeh. All rights reserved.
//

import Foundation

struct RoomType: Equatable {
    let id: Int
    let name: String
    let shortName: String
    let price: Int
    
    static var all: [RoomType] {
        return [RoomType(id: 0, name: "Two Queens", shortName: "2Q", price: 179),
                RoomType(id: 1, name: "One King", shortName: "K", price: 209),
                RoomType(id: 2, name: "Penthouse Suite", shortName: "PHS", price: 309)]
    }
    
    static func ==(lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
    
}



