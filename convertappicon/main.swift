//
//  main.swift
//  convert
//
//  Created by kreait on 28.03.18.
//  Copyright © 2018 kreait. All rights reserved.
//

import Foundation


if 2 > CommandLine.argc {
    Helper().output(.short)
    exit(-1)
}

let options = CommandLine.arguments[1..<Int(CommandLine.argc)-1]

if options.contains("-h") {
    Helper().output(.long)
    exit (0)
}

let prj = Project(path: CommandLine.arguments.last!)

guard let appIconPath = prj.findAppIconPath() else {
    print ("could not find app icon path")
    exit(-1)
}

guard let pdfPath = prj.findPdfPath(from: appIconPath) else {
    print ("could not find pdf path")
    exit(-1)
}

if options.contains("-c") {
    prj.cleanTarget(appIconPath: appIconPath)
}

guard let process = Processor(iconPath: appIconPath, pdfPath: pdfPath) else {
    print ("PDF cannot be opened")
    exit(-1)
}

var results = [Config]()
configurations.forEach {
    if process.convert(to: $0) {
        results.append($0)
        print ("'\($0.iconName)' created")
    }
}
if process.writeConfiguration(configurations: results) {
    print ("'Contents.json' created")
}
