//
//  music.swift
//  audioPlayer
//
//  Created by Vitaliy Shmelev on 04.06.2022.
//

import Foundation
import UIKit

struct Song {
    var image: UIImage
    var nameSong: String
    var artist: String
    var urlSong: String
}

extension Song {
    static func getSongs() -> [Song] {
        var storage = [Song]()
        let way = Bundle.main.paths(forResourcesOfType: ".mp3", inDirectory: "")
        
        way.forEach { urls in
            let url = URL(fileURLWithPath: urls)
            var fileName = url.lastPathComponent
            fileName.removeLast(4)
            let fullName = fileName.replacingOccurrences(of: "_", with: " ")
            let names = fullName.components(separatedBy: " ").map{ $0.replacingOccurrences(of: "-", with: " ")}
            let newElement = Song(image: UIImage(named: names.first!)!, nameSong: names.last!, artist: names.first! , urlSong: urls)
            storage.append(newElement)
        }
        return storage
    }
}
    
