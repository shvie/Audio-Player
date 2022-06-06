//
//  PlayerViewController.swift
//  audioPlayer
//
//  Created by Vitaliy Shmelev on 01.06.2022.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    var player = AVAudioPlayer()
    var timer: Timer?
    //MARK: - Elements
    let labelNameSongs: UILabel = {
        let labelEndTimeDuration = UILabel()
        labelEndTimeDuration.text = "label"
        labelEndTimeDuration.textColor = .lightGray
        labelEndTimeDuration.textAlignment = .center
        labelEndTimeDuration.alpha = 0.5
        labelEndTimeDuration.font = UIFont(name: "Helvetica Neue", size: 20)
        labelEndTimeDuration.translatesAutoresizingMaskIntoConstraints = false
        return labelEndTimeDuration
    }()
    
    let imageAlbum: UIImageView = {
        let imageAlbum = UIImageView()
        imageAlbum.layer.cornerRadius = 25.0
        imageAlbum.backgroundColor = .gray
        imageAlbum.translatesAutoresizingMaskIntoConstraints = false
        return imageAlbum
    }()
    
    let labelCurrentTimeDuration: UILabel = {
        let labelCurrentTimeDuration = UILabel()
        labelCurrentTimeDuration.text = "label"
        labelCurrentTimeDuration.textColor = .lightGray
        labelCurrentTimeDuration.textAlignment = .center
        labelCurrentTimeDuration.alpha = 0.5
        labelCurrentTimeDuration.font = UIFont(name: "Helvetica Neue", size: 14)
        labelCurrentTimeDuration.translatesAutoresizingMaskIntoConstraints = false
        return labelCurrentTimeDuration
    }()
    
    let labelEndTimeDuration: UILabel = {
        let labelEndTimeDuration = UILabel()
        labelEndTimeDuration.text = "label"
        labelEndTimeDuration.textColor = .lightGray
        labelEndTimeDuration.textAlignment = .center
        labelEndTimeDuration.alpha = 0.5
        labelEndTimeDuration.font = UIFont(name: "Helvetica Neue", size: 14)
        labelEndTimeDuration.translatesAutoresizingMaskIntoConstraints = false
        return labelEndTimeDuration
    }()
    var durationSlider : UISlider = {
        var durationSlider = UISlider()
        durationSlider.thumbTintColor = .lightGray
        durationSlider.tintColor = .white
        durationSlider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        durationSlider.minimumValue = 0.0
        durationSlider.translatesAutoresizingMaskIntoConstraints = false
       return durationSlider
    }()
    
    let buttonSelected: UIButton =  {
        let buttonSelected = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        buttonSelected.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: largeConfig), for: .normal)
        buttonSelected.tintColor = .black
        buttonSelected.translatesAutoresizingMaskIntoConstraints = false
       return buttonSelected
    }()
    let buttonBack: UIButton = {
        let buttonBack = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        buttonBack.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: largeConfig), for: .normal)
        buttonBack.tintColor = .black
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        return buttonBack
    }()
    let buttonPaused: UIButton = {
        let buttonPaused = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        buttonPaused.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: largeConfig), for: .normal)
        buttonPaused.tintColor = .black
        buttonPaused.translatesAutoresizingMaskIntoConstraints = false
        return buttonPaused
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        self.navigationItem.title = "Player"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        durationSlider.addTarget(self, action: #selector(valueChanged(_:)), for: .touchUpInside)
        buttonPaused.addTarget(self, action: #selector(pressPauseButton(_:)), for: .touchUpInside)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupButtonBack()
    }

    //MARK: - Methods


    @objc func pressPauseButton(_ sender: UIButton) {
        if player.isPlaying == true {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
            buttonPaused.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: largeConfig), for: .normal)
            player.pause()
        } else {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
            buttonPaused.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: largeConfig), for: .normal)
            player.play()
            
        }
    }
    @objc func updateTimer() {
        self.durationSlider.value = Float(player.currentTime)
        
        let currentTime = player.currentTime
        let minutes = Int(currentTime / 60)
        let seconds = Int(currentTime.truncatingRemainder(dividingBy: 60))
        labelCurrentTimeDuration.text = NSString(format: "%02d:%02d", minutes, seconds) as String
        
        let diffTime = player.duration - player.currentTime
        let diffmin = Int(diffTime / 60)
        let diffsec = Int(diffTime.truncatingRemainder(dividingBy: 60))
        labelEndTimeDuration.text = NSString(format: "%02d:%02d", diffmin, diffsec) as String
    }
    @objc func valueChanged(_ sender: UISlider) {
        self.player.currentTime = TimeInterval(self.durationSlider.value)
    }
    func settingsPlayer(titleSong: String) {
        let url = URL(fileURLWithPath: titleSong)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            durationSlider.maximumValue = Float(player.duration)
            
        } catch {
            print(error)
        }
    }
    
    //MARK: - CONSTRAINTS
    
    func setupButtonBack() {
        //Add SubViewsElements
        self.view.addSubview(buttonBack)
        self.view.addSubview(buttonPaused)
        self.view.addSubview(buttonSelected)
        self.view.addSubview(durationSlider)
        self.view.addSubview(labelEndTimeDuration)
        self.view.addSubview(imageAlbum)
        self.view.addSubview(labelNameSongs)
        self.view.addSubview(labelCurrentTimeDuration)
        
        //Constraints for "buttonBack"
        buttonBack.centerYAnchor.constraint(equalTo: buttonPaused.centerYAnchor).isActive = true
        buttonBack.rightAnchor.constraint(equalTo: buttonPaused.leftAnchor, constant: -20).isActive = true
        buttonBack.heightAnchor.constraint(equalToConstant: 25).isActive = true
        buttonBack.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        //Constraints for "buttonPaused"
        buttonPaused.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonPaused.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonPaused.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonPaused.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        
        //Constraints For "buttonSelected"
        buttonSelected.leftAnchor.constraint(equalTo: buttonPaused.rightAnchor, constant: 20).isActive = true
        buttonSelected.centerYAnchor.constraint(equalTo: buttonPaused.centerYAnchor).isActive = true
        buttonSelected.widthAnchor.constraint(equalToConstant: 25).isActive = true
        buttonSelected.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //Constraints for "sliderDuration"
        durationSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        durationSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        durationSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        durationSlider.bottomAnchor.constraint(equalTo: buttonPaused.topAnchor, constant: -20).isActive = true
        
        //Constraints for "labelEndTimeDuration"
        labelEndTimeDuration.rightAnchor.constraint(equalTo: durationSlider.rightAnchor).isActive = true
        labelEndTimeDuration.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 2).isActive = true
        
        //Constraints for "imageAlbum"
        imageAlbum.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageAlbum.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        imageAlbum.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageAlbum.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        imageAlbum.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2).isActive = true
        
        //Constraints for "labelNameSongs"
        labelNameSongs.leftAnchor.constraint(equalTo: imageAlbum.leftAnchor).isActive = true
        labelNameSongs.topAnchor.constraint(equalTo: imageAlbum.bottomAnchor, constant: 10).isActive = true
        
        //Constraints for "labelCurrentTimeDuration"
        labelCurrentTimeDuration.leftAnchor.constraint(equalTo: durationSlider.leftAnchor).isActive = true
        labelCurrentTimeDuration.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 2).isActive = true
        
    }
    
    

    
    
    
    
    
}

