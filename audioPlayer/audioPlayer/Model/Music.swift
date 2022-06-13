//
//  music.swift
//  audioPlayer
//
//  Created by Vitaliy Shmelev on 04.06.2022.
//

import Foundation
import UIKit

protocol SongProtocol {
    var nameSongs: [String] {get}
    var urlFile: [String] {get}
}

struct Song: SongProtocol {
    //MARK: индексы названий и индексы путей к файлам соответствуют друг другу
    var imageAlbum: [String] = {
        let way = Bundle.main.paths(forResourcesOfType: ".png", inDirectory: "")
        return way
    }()
    //Путь к файлам для аудио плеера
    var urlFile: [String] = {
        let way = Bundle.main.paths(forResourcesOfType: ".mp3", inDirectory: "")
        return way
    }()
    
    //Названия песен
    var nameSongs: [String] = {
        //Получаем путь
        let way = Bundle.main.paths(forResourcesOfType: ".mp3", inDirectory: "")
        //убираем не нужные символы
        let newNames: [String] = way.compactMap { elements in
            let url = URL(fileURLWithPath: elements)
            var fileName = url.lastPathComponent
            fileName.removeLast(4)
            let complete = fileName.replacingOccurrences(of: "-", with: " ")
            return complete
        }
        return newNames
    }()
}
