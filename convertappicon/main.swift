//
//  main.swift
//  convert
//
//  Created by kreait on 28.03.18.
//  Copyright © 2018 kreait. All rights reserved.
//

import Foundation


if 2 != CommandLine.argc {
    print ("convert SRCROOT")
    exit(-1)
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

guard let process = Processor(iconPath: appIconPath, pdfPath: pdfPath) else {
    print ("PDF cannot be opened")
    exit(-1)
}

configurations.forEach {
    if process.convert(to: $0) {
        print ("'\($0.iconName)' created")
    }
}
if process.writeConfiguration(configurations: configurations) {
    print ("'Contents.json' created")
}
