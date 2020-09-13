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
    case watch = "watch"
    case watchMarketing = "watch-marketing"
}

enum Role: String, Encodable {
    
    case notificationCenter
    case companionSettings
    case appLauncher
    case longLook
    case quickLook
}

struct Config: Encodable {
    
    let size: Float
    let idiom: Idiom
    let scale: Int
    let role: Role?
    let subtype: String?

    init(size: Float, idiom: Idiom, scale: Int, role: Role? = nil, subtype: String? = nil) {
        self.size = size
        self.idiom = idiom
        self.scale = scale
        self.role = role
        self.subtype = subtype
    }

    var iconName: String {
        return "Icon-\(Int(size * Float(scale))).png"
    }

    enum CodingKeys: String, CodingKey {
        case size
        case idiom
        case scale
        case role
        case subtype
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
        if let role = role {
            try container.encode(role, forKey: .role)
        }
        if let subtype = subtype {
            try container.encode(subtype, forKey: .subtype)
        }
    }
}

struct Configuration {
    
    static let list = [Config(size: 20, idiom: .phone, scale: 2),
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

                       Config(size: 24, idiom: .watch, scale: 2, role: .notificationCenter, subtype: "38mm"),
                       Config(size: 27.5, idiom: .watch, scale: 2, role: .notificationCenter, subtype: "42mm"),

                       Config(size: 29, idiom: .watch, scale: 2, role: .companionSettings),
                       Config(size: 29, idiom: .watch, scale: 3, role: .companionSettings),

                       Config(size: 86, idiom: .watch, scale: 2, role: .quickLook, subtype: "38mm"),
                       Config(size: 98, idiom: .watch, scale: 2, role: .quickLook, subtype: "42mm"),
                       Config(size: 108, idiom: .watch, scale: 2, role: .quickLook, subtype: "44mm"),

                       Config(size: 40, idiom: .watch, scale: 2, role: .appLauncher, subtype: "38mm"),
                       Config(size: 44, idiom: .watch, scale: 2, role: .appLauncher, subtype: "40mm"),
                       Config(size: 50, idiom: .watch, scale: 2, role: .appLauncher, subtype: "44mm"),

                       Config(size: 1024, idiom: .watchMarketing, scale: 1),
                       Config(size: 1024, idiom: .marketing, scale: 1)]
}
