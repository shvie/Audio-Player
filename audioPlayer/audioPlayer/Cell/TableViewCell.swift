//
//  TableViewCell.swift
//  audioPlayer
//
//  Created by Vitaliy Shmelev on 04.06.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    let identifer = "Cells"
    
    lazy var trackImage: UIImageView = {
        let trackImage = UIImageView()
        trackImage.backgroundColor = .black
        trackImage.clipsToBounds = true
        trackImage.translatesAutoresizingMaskIntoConstraints = false
        return trackImage
    }()
    lazy var labelNameSongs: UILabel = {
       let labelNameSongs = UILabel()
        labelNameSongs.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        labelNameSongs.text = "Label"
        labelNameSongs.textColor = .black
        labelNameSongs.translatesAutoresizingMaskIntoConstraints = false
        return labelNameSongs
    }()
    lazy var labelNameArtist: UILabel = {
        let labelNameArtist = UILabel()
        labelNameArtist.font = UIFont.systemFont(ofSize: 14, weight: .light)
        labelNameArtist.text = "Label"
        labelNameArtist.textColor = .black
        labelNameArtist.translatesAutoresizingMaskIntoConstraints = false
        return labelNameArtist
    }()
    lazy var buttonForShare: UIButton = {
        let buttonForShare = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20)
        buttonForShare.setImage(UIImage(systemName: "arrowshape.turn.up.right", withConfiguration: largeConfig), for: .normal)
        buttonForShare.setImage(UIImage(systemName: "arrowshape.turn.up.forward.fill",withConfiguration: largeConfig), for: .highlighted)
        buttonForShare.tintColor = .lightGray
        buttonForShare.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        buttonForShare.translatesAutoresizingMaskIntoConstraints = false
        return buttonForShare
    }()
    var actionHandler: ((TableViewCell) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func didTapButton() {
        actionHandler?(self)
    }
    //MARK: - COnstraints
    func constraints() {
        contentView.addSubview(trackImage)
        contentView.addSubview(labelNameSongs)
        contentView.addSubview(labelNameArtist)
        contentView.addSubview(buttonForShare)
        NSLayoutConstraint.activate([
        trackImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
        trackImage.widthAnchor.constraint(equalToConstant: sqrt(self.contentView.frame.size.width * self.contentView.frame.size.height) / 2),
        trackImage.heightAnchor.constraint(equalTo: trackImage.widthAnchor),
        trackImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
        labelNameSongs.leftAnchor.constraint(equalTo: trackImage.rightAnchor, constant: 10),
        labelNameSongs.topAnchor.constraint(equalTo: trackImage.topAnchor),
        
        labelNameArtist.topAnchor.constraint(equalTo: labelNameSongs.bottomAnchor, constant: 5),
        labelNameArtist.leftAnchor.constraint(equalTo: trackImage.rightAnchor, constant: 10),
        
        buttonForShare.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        buttonForShare.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        buttonForShare.widthAnchor.constraint(equalToConstant: sqrt(contentView.frame.size.height * contentView.frame.size.width) / 3),
        buttonForShare.heightAnchor.constraint(equalTo: buttonForShare.widthAnchor)
        ])
        

    }

}
