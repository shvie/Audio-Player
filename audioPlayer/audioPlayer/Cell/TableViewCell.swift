//
//  TableViewCell.swift
//  audioPlayer
//
//  Created by Vitaliy Shmelev on 04.06.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    let identifer = "Cell"
    let trackImage: UIImageView = {
        let trackImage = UIImageView()
        trackImage.backgroundColor = .black
        trackImage.layer.cornerRadius = 20
        trackImage.translatesAutoresizingMaskIntoConstraints = false
        return trackImage
    }()
    let labelNameSongs: UILabel = {
       let labelNameSongs = UILabel()
        labelNameSongs.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        labelNameSongs.text = "Label"
        labelNameSongs.textColor = .black
        labelNameSongs.translatesAutoresizingMaskIntoConstraints = false
        return labelNameSongs
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - COnstraints
    func constraints() {
        contentView.addSubview(trackImage)
        contentView.addSubview(labelNameSongs)
        trackImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        trackImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        trackImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        trackImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        labelNameSongs.leftAnchor.constraint(equalTo: trackImage.rightAnchor, constant: 10).isActive = true
        labelNameSongs.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        
        
    }

}
