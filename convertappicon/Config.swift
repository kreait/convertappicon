//
//  Image.swift
//  convert
//
//  Created by kreait on 30.03.18.
//  Copyright © 2018 kreait. All rights reserved.
//

import Foundation


enum Idiom: String, Encodable {

    case phone = "iphone"
    case pad = "ipad"
    case marketing = "ios-marketing"
}

struct Config: Encodable {

    let size: Float
    let idiom: Idiom
    let scale: Int

    var iconName: String {
        return "Icon-\(Int(size * Float(scale))).png"
    }
    
    enum CodingKeys: String, CodingKey {
        case size
        case idiom
        case scale
        case filename
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if Int(size) == Int(size.rounded()) {   // uh
            try container.encode("\(Int(size))x\(Int(size))", forKey: .size)
        }
        else {
            try container.encode("\(size)x\(size)", forKey: .size)
        }
        try container.encode(idiom, forKey: .idiom)
        try container.encode("\(scale)x", forKey: .scale)
        try container.encode(iconName, forKey: .filename)
    }
}

let configurations = [Config(size: 20, idiom: .phone, scale: 2),
                      Config(size: 20, idiom: .phone, scale: 3),
                      Config(size: 29, idiom: .phone, scale: 2),
                      Config(size: 29, idiom: .phone, scale: 3),
                      Config(size: 40, idiom: .phone, scale: 2),
                      Config(size: 40, idiom: .phone, scale: 3),
                      Config(size: 60, idiom: .phone, scale: 2),
                      Config(size: 60, idiom: .phone, scale: 3),
                      Config(size: 20, idiom: .pad, scale: 1),
                      Config(size: 20, idiom: .pad, scale: 2),
                      Config(size: 29, idiom: .pad, scale: 1),
                      Config(size: 29, idiom: .pad, scale: 2),
                      Config(size: 40, idiom: .pad, scale: 1),
                      Config(size: 40, idiom: .pad, scale: 2),
                      Config(size: 76, idiom: .pad, scale: 1),
                      Config(size: 76, idiom: .pad, scale: 2),
                      Config(size: 83.5, idiom: .pad, scale: 2),
                      Config(size: 1024, idiom: .marketing, scale: 1)]
