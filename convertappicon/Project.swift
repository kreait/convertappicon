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
        do {
            let list = try FileManager.default.contentsOfDirectory(atPath: basepath)
            if let hit = list.first(where: { $0.contains(name) } ) {
                let result = "\(basepath)/\(hit)"
                return result
            }
            else {
                let results = list.filter({ $0.prefix(1) != "." }).compactMap { find(name: name, basepath: "\(basepath)/\($0)")}
                return results.first
            }
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
}
