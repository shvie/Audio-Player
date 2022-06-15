//
//  ListSongs.swift
//  audioPlayer
//
//  Created by Vitaliy Shmelev on 04.06.2022.
//
import Foundation
import UIKit

class ListSongs: UITableViewController {
    
   //MARK: - Elements
    var storage: [Song] = Song.getSongs()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Songs"
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cells")
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storage.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) as! TableViewCell
        cell.labelNameSongs.text = storage[indexPath.row].nameSong
        cell.trackImage.image = storage[indexPath.row].image
        cell.labelNameArtist.text = storage[indexPath.row].artist
        cell.trackImage.layer.cornerRadius = 10

        cell.actionHandler = {[unowned self] cell in
            let content = "Смотри что я нашел - \(cell.labelNameArtist.text!)" + "-" + "\(cell.labelNameSongs.text!)"
            let image = cell.trackImage.image!
            let devUrl = URL(string: "https://github.com/shvie")!
            let vc = UIActivityViewController(activityItems: [devUrl, content,image], applicationActivities: nil)
            DispatchQueue.main.async {
            self.present(vc, animated: true)
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = PlayerViewController()
        playerVC.storage = self.storage
        playerVC.player(elementForPlay: storage[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.present(playerVC, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = sqrt(self.view.frame.size.height * self.view.frame.size.width) / 8
        
        return height
    }

    

    
}


