//
//  main.swift
//  convert
//
//  Created by kreait on 28.03.18.
//  Copyright © 2018 kreait. All rights reserved.
//

import Foundation


if 2 > CommandLine.argc {
    Helper.output(verbose: false)
    exit(-1)
}

let options = CommandLine.arguments[1..<Int(CommandLine.argc)-1]

if options.contains("-h") {
    Helper.output(verbose: true)
    exit (0)
}

let path = CommandLine.arguments.last!
let prj = Project(path: path)

guard let appIconPath = prj.findAppIconPath() else {
    print ("Could not find app icons path in '\(path)'.")
    exit(-1)
}

guard let pdfPath = prj.findPdfPath(from: appIconPath) else {
    print ("Could not find pdf path in '\(path)'.")
    exit(-1)
}

if options.contains("-t") {
    print("app icons path: \(appIconPath)")
    print("pdf path: \(pdfPath)")
}
else if options.contains("-c") {
    prj.cleanTarget(appIconPath: appIconPath)
}

guard let process = Processor(iconPath: appIconPath, pdfPath: pdfPath) else {
    print ("The pdf cannot be opened")
    exit(-1)
}

var configs = Configuration.list
if options.contains("-s") {
    configs = []
    if options.contains("iphone") {
        configs.append(contentsOf: Configuration.list.filter { $0.idiom == .phone } )
    }
    if options.contains("ipad") {
        configs.append(contentsOf: Configuration.list.filter { $0.idiom == .pad } )
    }
    if options.contains("marketing") {
        configs.append(contentsOf: Configuration.list.filter { $0.idiom == .marketing } )
    }
    if options.contains("watch") {
        configs.append(contentsOf: Configuration.list.filter { $0.idiom == .watch || $0.idiom == .watchMarketing } )
    }
    if configs.isEmpty {
        print("Warning: -s given but no category found.")
    }
}

var resultConfigs = [Config]()
configs.forEach {
    if options.contains("-t") {
        print ("'\(appIconPath)/\($0.iconName)'")
    }
    else if process.convert(to: $0) {
        resultConfigs.append($0)
        print ("'\(appIconPath)/\($0.iconName)' created")
    }
}

if !options.contains("-t") && process.writeConfiguration(configurations: resultConfigs) {
    print ("'\(appIconPath)/Contents.json' created")
}
