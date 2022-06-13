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
    let storage = Song()
    var countSong = 1
    var repeating = false
    
    //MARK: - Elements
    
    let labelNameSongs: UILabel! = {
        let labelNameSongs = UILabel()
        labelNameSongs.text = "label"
        labelNameSongs.textColor = .lightGray
        labelNameSongs.textAlignment = .center
        labelNameSongs.alpha = 0.5
        labelNameSongs.font = UIFont.boldSystemFont(ofSize: 20)
        labelNameSongs.translatesAutoresizingMaskIntoConstraints = false
        return labelNameSongs
    }()
    
    let labelNameArtist: UILabel = {
        let labelEndTimeDuration = UILabel()
        labelEndTimeDuration.text = "label"
        labelEndTimeDuration.textColor = .lightGray
        labelEndTimeDuration.textAlignment = .center
        labelEndTimeDuration.alpha = 0.5
        labelEndTimeDuration.font = UIFont(name: "Helvetica Neue", size: 20)
        labelEndTimeDuration.translatesAutoresizingMaskIntoConstraints = false
        return labelEndTimeDuration
    }()
    
    let stackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let imageAlbum: UIImageView = {
        let imageAlbum = UIImageView()
        imageAlbum.contentMode = .scaleAspectFill
        imageAlbum.layer.cornerRadius = 25.0
        imageAlbum.backgroundColor = .gray
        imageAlbum.clipsToBounds = true
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
   let durationSlider : UISlider = {
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
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        buttonSelected.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: largeConfig), for: .normal)
        buttonSelected.tintColor = .black
        buttonSelected.backgroundColor = .blue
//        buttonSelected.translatesAutoresizingMaskIntoConstraints = false
        buttonSelected.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
       return buttonSelected
    }()
    let buttonBack: UIButton = {
        let buttonBack = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        buttonBack.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: largeConfig), for: .normal)
        buttonBack.tintColor = .black
        buttonBack.backgroundColor = .blue
        buttonBack.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        return buttonBack
    }()
    
    let buttonPaused: UIButton = {
        let buttonPaused = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        buttonPaused.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: largeConfig), for: .normal)
        buttonPaused.tintColor = .black
        buttonPaused.backgroundColor = .blue
        buttonPaused.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        buttonPaused.translatesAutoresizingMaskIntoConstraints = false
        return buttonPaused
    }()
    let buttonRepeat: UIButton = {
        let buttonRepeat = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        buttonRepeat.setImage(UIImage(systemName: "repeat.1", withConfiguration:largeConfig ), for: .normal)
        buttonRepeat.tintColor = .lightGray
        buttonRepeat.alpha = 0.5
        buttonRepeat.backgroundColor = .blue
        buttonRepeat.translatesAutoresizingMaskIntoConstraints = false
        buttonRepeat.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return buttonRepeat
    }()
    
    let buttonShareActivity: UIButton = {
        let buttonShareActivity = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        buttonShareActivity.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: largeConfig), for: .normal)
        buttonShareActivity.tintColor = .lightGray
        buttonShareActivity.alpha = 0.5
        buttonShareActivity.translatesAutoresizingMaskIntoConstraints = false
        return buttonShareActivity
    }()
    
    //MARK: - LifeCycle
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        self.navigationItem.title = "Player"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        buttonPaused.addTarget(self, action: #selector(pressPauseButton(_:)), for: .touchUpInside)
        buttonSelected.addTarget(self, action: #selector(pressSelectedButton(_:)), for: .touchUpInside)
        buttonBack.addTarget(self, action: #selector(pressBackButton(_:)), for: .touchUpInside)
        buttonRepeat.addTarget(self, action: #selector(pressRepeatButton(_:)), for: .touchUpInside)
        durationSlider.addTarget(self, action: #selector(setSliderValue(_:)), for: .touchUpInside)
        buttonShareActivity.addTarget(self, action: #selector(presentActivity), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupButtonBack()
    }

    //MARK: - Methods
    @objc func presentActivity() {
//        let viewController = UIActivityViewController(activityItems: [imageAlbum.image], applicationActivities: nil)
        


        
        
        let s = UIActivityViewController(activityItems: [imageAlbum.image], applicationActivities: [])
        self.present(s, animated: true)
        
    }
    @objc func setSliderValue(_ sender: UISlider) {
        player.currentTime = TimeInterval(sender.value)
    }
    
    @objc func pressRepeatButton(_ sender: UIButton){
        if repeating == false {
            buttonRepeat.alpha = 1
            repeating = true
            sender.tintColor = .white
            player.numberOfLoops = -1
        } else {
            repeating = false
            buttonRepeat.alpha = 0.5
            player.numberOfLoops = 0
            sender.tintColor = .lightGray
            
        }
    }
    //Действие для кнопки назад в плеере
    @objc func pressBackButton(_ sender: UIButton){
        if countSong == 0 {
            countSong = storage.urlFile.count
        }
        guard countSong > storage.urlFile.count else {
                countSong = countSong - 1
            print(countSong)
            settingsPlayer(titleSong: storage.urlFile[countSong], nameSong: storage.nameSongs[countSong])
            return
            }
        }
    //Действие для кнопки дальше в плеере
    @objc func pressSelectedButton(_ sender: UIButton) {
        guard countSong >= storage.urlFile.count else {
            countSong += 1
            print(countSong)
            settingsPlayer(titleSong: storage.urlFile[countSong - 1], nameSong: storage.nameSongs[countSong - 1])
            if countSong == storage.urlFile.count {
                countSong = 0
            }
            return
        }
    }
    //Действие для кнопки паузы в плеере
    @objc func pressPauseButton(_ sender: UIButton) {
        if player.isPlaying == true {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
            buttonPaused.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: largeConfig), for: .normal)
            player.pause()
        } else {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
            buttonPaused.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: largeConfig), for: .normal)
            player.play()
        }
    }
    //таймер для отслеживания времени трека
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
    //включение выбранного трека
    func settingsPlayer(titleSong: String, nameSong: String) {
        imageAlbum.image = UIImage(named: "thexx")
        labelNameArtist.text = nameSong.components(separatedBy: " ").dropLast().joined(separator: " ")
        let strWith = nameSong.split(separator: " ")
        let nameSongs = String(strWith.suffix(1).joined(separator: [" "]))
        labelNameSongs.text = nameSongs
        
        let url = URL(fileURLWithPath: titleSong)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            durationSlider.maximumValue = Float(player.duration)
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
            buttonPaused.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: largeConfig), for: .normal)
            player.play()
        } catch {
            print(error)
        }
    }
    
    //MARK: - CONSTRAINTS
    
    func setupButtonBack() {
        //Add SubViewsElements
        //self.view.addSubview(buttonBack)
        //self.view.addSubview(buttonPaused)
        //self.view.addSubview(buttonSelected)
        stackView.addArrangedSubview(buttonBack)
        stackView.addArrangedSubview(buttonPaused)
        stackView.addArrangedSubview(buttonSelected)
        
        
        self.view.addSubview(durationSlider)
        self.view.addSubview(labelEndTimeDuration)
        self.view.addSubview(imageAlbum)
        self.view.addSubview(labelNameArtist)
        self.view.addSubview(labelCurrentTimeDuration)
        self.view.addSubview(labelNameSongs)
        self.view.addSubview(buttonRepeat)
        self.view.addSubview(buttonShareActivity)
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: labelEndTimeDuration.bottomAnchor, constant: 5),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: buttonRepeat.leadingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        //Constraints for "buttonBack"
//            buttonBack.centerYAnchor.constraint(equalTo: buttonPaused.centerYAnchor),
//        buttonBack.rightAnchor.constraint(equalTo: buttonPaused.leftAnchor, constant: -20),
//        buttonBack.heightAnchor.constraint(equalToConstant: 25),
//        buttonBack.widthAnchor.constraint(equalToConstant: 25),
        
        //Constraints for "buttonPaused"
//        buttonPaused.centerXAnchor.constraint(equalTo: view.centerXAnchor),
////        buttonPaused.heightAnchor.constraint(equalToConstant: 60),
////        buttonPaused.widthAnchor.constraint(equalToConstant: 60),
//            buttonPaused.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
//            buttonPaused.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50),
//        buttonPaused.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        
        //Constraints For "buttonSelected"
//        buttonSelected.leftAnchor.constraint(equalTo: buttonPaused.rightAnchor, constant: 20),
//        buttonSelected.centerYAnchor.constraint(equalTo: buttonPaused.centerYAnchor),
//        buttonSelected.widthAnchor.constraint(equalToConstant: 25),
//        buttonSelected.heightAnchor.constraint(equalToConstant: 25),
//
        //Constraints for "sliderDuration"
        durationSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        durationSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        durationSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            durationSlider.topAnchor.constraint(equalTo: labelNameSongs.bottomAnchor, constant: 50),
        
        //Constraints for "labelEndTimeDuration"
        labelEndTimeDuration.rightAnchor.constraint(equalTo: durationSlider.rightAnchor),
        labelEndTimeDuration.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 2),
        
        //Constraints for "imageAlbum"
        imageAlbum.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        imageAlbum.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
//        imageAlbum.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
//        imageAlbum.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),

//        imageAlbum.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),
            imageAlbum.heightAnchor.constraint(equalToConstant: sqrt(self.view.frame.size.width * self.view.frame.size.height) / 2),
            imageAlbum.widthAnchor.constraint(equalTo: imageAlbum.heightAnchor),
            
        //Constraints for "labelNameArtist"
        labelNameArtist.leftAnchor.constraint(equalTo: imageAlbum.leftAnchor),
        labelNameArtist.topAnchor.constraint(equalTo: labelNameSongs.bottomAnchor, constant: 2),
        
        //Constraints for "labelCurrentTimeDuration"
        labelCurrentTimeDuration.leftAnchor.constraint(equalTo: durationSlider.leftAnchor),
        labelCurrentTimeDuration.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 2),
        
        //Constraints for "labelNameSongs"
        labelNameSongs.leftAnchor.constraint(equalTo: imageAlbum.leftAnchor),
        labelNameSongs.topAnchor.constraint(equalTo: imageAlbum.bottomAnchor, constant: 10),
        
//        Constraints for "ButtonRepeat"
//        buttonRepeat.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        buttonRepeat.heightAnchor.constraint(equalToConstant: 30),
        buttonRepeat.widthAnchor.constraint(equalToConstant: 30),
        buttonRepeat.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
        
        //Constraints for "ButtonShareActivity"
        buttonShareActivity.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            buttonShareActivity.heightAnchor.constraint(equalToConstant: 25),
        buttonShareActivity.widthAnchor.constraint(equalToConstant: 23),
        buttonShareActivity.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15)
        ])
    }
    
    

    
    
    
    
    
}

