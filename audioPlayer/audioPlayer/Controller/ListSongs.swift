//
//  ListSongs.swift
//  audioPlayer
//
//  Created by Vitaliy Shmelev on 04.06.2022.
//

import UIKit

class ListSongs: UITableViewController {
    
    var data = Song()
    
   //MARK: - Elements
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Переход на следущую сцену", for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Songs"
        button.addTarget(self, action: #selector(selectedScene), for: .touchUpInside)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 50
        print(data.nameSongs)
        self.tableView.inputAccessoryView?.addSubview(UIImageView(image: UIImage(systemName: "circle")))
        //setupButton()
        
    }
    //MARK: - Methods
    @objc func selectedScene() {
        lazy var reference = PlayerViewController()
        self.navigationController?.present(reference, animated: true)
    }
    
    //MARK: - Constraints
    func setupButton() {
        view.addSubview(button)
        button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        button.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 1).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.nameSongs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.labelNameSongs.text = data.nameSongs[indexPath.row]
        cell.trackImage.image = UIImage(named: "thexx")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = PlayerViewController()
        self.navigationController?.present(playerVC, animated: true)
        playerVC.settingsPlayer(titleSong: data.urlFile[indexPath.row], nameSong: data.nameSongs[indexPath.row])
    }
    
}


