//
//  Image.swift
//  convert
//
//  Created by kreait on 29.03.18.
//  Copyright © 2018 kreait. All rights reserved.
//

import Foundation
import AppKit


struct Processor {

    private var iconPath: String
    private var pdfPath: String

    private var sourceImage: NSImage
    
    init?(iconPath: String, pdfPath: String) {

        self.iconPath = iconPath
        self.pdfPath = pdfPath
        guard let sourceImage = NSImage(contentsOfFile: pdfPath) else {
            return nil
        }
        self.sourceImage = sourceImage
    }

    func convert(to config: Config) -> Bool {

        let size = CGFloat(config.size * Float(config.scale))
        let rect = NSRect(x: 0, y: 0, width: size, height: size)

        // create non-retina image rep, uh
        guard let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size), pixelsHigh: Int(size), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0) else { return false }
        rep.size = NSSize(width: size, height: size)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        sourceImage.draw(in: rect, from: NSRect(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height), operation: .copy, fraction: 1)
        NSGraphicsContext.restoreGraphicsState()
        
        guard let pngData = rep.representation(using: .png, properties: [:]) else { return false }

        let name = "\(self.iconPath)/\(config.iconName)"
        do {
            try pngData.write(to: URL(fileURLWithPath: name))
        }
        catch {
            print(error)
            return false
        }
        return true
    }
    
    func writeConfiguration(configurations: [Config]) -> Bool {
        
        struct Contents: Encodable {
            
            struct Info: Encodable {
                let version: Int
                let author: String
            }
            
            var info: Info
            var images: [Config]
        }

        let contents = Contents(info: Contents.Info(version: 1, author: "xcode"), images: configurations)
        
        let name = "\(self.iconPath)/Contents.json"
        
        do {
            let data = try JSONEncoder().encode(contents)
            try data.write(to: URL(fileURLWithPath: name))
        }
        catch {
            print(error)
            return false
        }
        return true
    }
}
