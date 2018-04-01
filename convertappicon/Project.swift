//
//  Project.swift
//  convert
//
//  Created by kreait on 29.03.18.
//  Copyright © 2018 kreait. All rights reserved.
//

import Foundation


class Project {
    
    private let path: String

    init(path: String) {
        self.path = path
    }

    private func find(name: String, basepath: String) -> String? {
        guard !basepath.contains(name) else { return basepath }
        do {
            let list = try FileManager.default.contentsOfDirectory(atPath: basepath)
            let results = list.filter({ $0.prefix(1) != "." })
                            .compactMap { find(name: name, basepath: "\(basepath)/\($0)") }
            guard let result = results.first else { return nil }
            guard FileManager.default.fileExists(atPath: result) else { return nil }
            return result
        }
        catch {
//            print(error)
            return nil
        }
    }

    func findAppIconPath() -> String? {
        return find(name: ".appiconset", basepath: path)
    }

    func findPdfPath(from appIconPath:String) -> String? {
        let comps = appIconPath.components(separatedBy: "/")
        guard let fullname = comps.last else { return nil }
        guard let name = fullname.components(separatedBy: ".").first else { return nil }
        let head = comps.dropLast()
        let resultPath = "\(head.joined(separator: "/"))/\(name)Pdf.imageset"
        return find(name: ".pdf", basepath: resultPath)
    }

    func cleanTarget(appIconPath: String) {
        do {
            let list = try FileManager.default.contentsOfDirectory(atPath: appIconPath)
            try list.filter({ $0.prefix(1) != "." })
                    .forEach { try FileManager.default.removeItem(atPath: "\(appIconPath)/\($0)") }
        }
        catch {
            //            print(error)
        }
    }

}
