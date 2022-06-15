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
    var storage: [Song] = []
    var countSong = 1
    var repeating = false
    
    //MARK: - Elements
    
    lazy var labelNameSongs: UILabel! = {
        let labelNameSongs = UILabel()
        labelNameSongs.text = "label"
        labelNameSongs.textColor = .lightGray
        labelNameSongs.textAlignment = .left
        labelNameSongs.alpha = 0.5
        labelNameSongs.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        labelNameSongs.translatesAutoresizingMaskIntoConstraints = false
        return labelNameSongs
    }()
    
    lazy var labelNameArtist: UILabel = {
        let labelEndTimeDuration = UILabel()
        labelEndTimeDuration.text = "label"
        labelEndTimeDuration.textColor = .lightGray
        labelEndTimeDuration.textAlignment = .left
        labelEndTimeDuration.alpha = 0.5
        labelEndTimeDuration.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        labelEndTimeDuration.translatesAutoresizingMaskIntoConstraints = false
        return labelEndTimeDuration
    }()
    
    lazy var stackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .fill
        stackView.spacing = -25
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var imageAlbum: UIImageView = {
        let imageAlbum = UIImageView()
        imageAlbum.contentMode = .scaleAspectFill
        imageAlbum.layer.cornerRadius = 25.0
        imageAlbum.backgroundColor = .gray
        imageAlbum.clipsToBounds = true
        imageAlbum.translatesAutoresizingMaskIntoConstraints = false
        return imageAlbum
    }()
    
    lazy var labelCurrentTimeDuration: UILabel = {
        let labelCurrentTimeDuration = UILabel()
        labelCurrentTimeDuration.text = "label"
        labelCurrentTimeDuration.textColor = .lightGray
        labelCurrentTimeDuration.textAlignment = .center
        labelCurrentTimeDuration.alpha = 0.5
        labelCurrentTimeDuration.font = UIFont(name: "Helvetica Neue", size: 14)
        labelCurrentTimeDuration.translatesAutoresizingMaskIntoConstraints = false
        return labelCurrentTimeDuration
    }()
    
    lazy var labelEndTimeDuration: UILabel = {
        let labelEndTimeDuration = UILabel()
        labelEndTimeDuration.text = "label"
        labelEndTimeDuration.textColor = .lightGray
        labelEndTimeDuration.textAlignment = .center
        labelEndTimeDuration.alpha = 0.5
        labelEndTimeDuration.font = UIFont(name: "Helvetica Neue", size: 14)
        labelEndTimeDuration.translatesAutoresizingMaskIntoConstraints = false
        return labelEndTimeDuration
    }()
    lazy var durationSlider : UISlider = {
        var durationSlider = UISlider()
        durationSlider.thumbTintColor = .lightGray
        durationSlider.tintColor = .white
        durationSlider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        durationSlider.minimumValue = 0.0
        durationSlider.translatesAutoresizingMaskIntoConstraints = false
        durationSlider.addTarget(self, action: #selector(setSliderValue(_:)), for: .touchUpInside)
        return durationSlider
    }()
    
    lazy var buttonSelected: UIButton =  {
        let buttonSelected = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: sqrt(self.view.frame.height * self.view.frame.width) / 14, weight: .bold, scale: .large)
        buttonSelected.setImage(UIImage(systemName: "forward.end.fill", withConfiguration: largeConfig), for: .normal)
        buttonSelected.tintColor = .black
        buttonSelected.addTarget(self, action: #selector(pressSelectedButton), for: .touchUpInside)
        return buttonSelected
    }()
    
    lazy var buttonBack: UIButton = {
        let buttonBack = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: sqrt(self.view.frame.height * self.view.frame.width) / 14, weight: .bold, scale: .large)
        buttonBack.setImage(UIImage(systemName: "backward.end.fill", withConfiguration: largeConfig), for: .normal)
        buttonBack.tintColor = .black
        buttonBack.addTarget(self, action: #selector(pressBackButton(_:)), for: .touchUpInside)
        return buttonBack
    }()
    
    lazy var buttonPaused: UIButton = {
        let buttonPaused = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: sqrt(self.view.frame.height * self.view.frame.width) / 9, weight: .bold, scale: .large)
        buttonPaused.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: largeConfig), for: .normal)
        buttonPaused.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: largeConfig), for: .selected)
        buttonPaused.tintColor = .black
        buttonPaused.addTarget(self, action: #selector(pressPauseButton), for: .touchUpInside)
        return buttonPaused
    }()
    
    lazy var buttonRepeat: UIButton = {
        let buttonRepeat = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: sqrt(self.view.frame.height * self.view.frame.width) / 25, weight: .bold, scale: .large)
        buttonRepeat.setImage(UIImage(systemName: "repeat.1", withConfiguration:largeConfig ), for: .normal)
        buttonRepeat.tintColor = .lightGray
        buttonRepeat.alpha = 0.5
        buttonRepeat.translatesAutoresizingMaskIntoConstraints = false
        buttonRepeat.addTarget(self, action: #selector(pressRepeatButton(_:)), for: .touchUpInside)
        return buttonRepeat
    }()
    
    lazy var buttonShareActivity: UIButton = {
        let buttonShareActivity = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: sqrt(self.view.frame.height * self.view.frame.width) / 20, weight: .bold, scale: .large)
        buttonShareActivity.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: largeConfig), for: .normal)
        buttonShareActivity.tintColor = .lightGray
        buttonShareActivity.alpha = 0.5
        buttonShareActivity.translatesAutoresizingMaskIntoConstraints = false
        buttonShareActivity.addTarget(self, action: #selector(presentActivity(_:)), for: .touchUpInside)
        return buttonShareActivity
    }()
    lazy var buttonShusffle: UIButton = {
        let buttonShuffle = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: sqrt(self.view.frame.height * self.view.frame.width) / 25, weight: .bold, scale: .large)
        buttonShuffle.setImage(UIImage(systemName: "shuffle",withConfiguration: largeConfig), for: .normal)
        buttonShuffle.tintColor = .lightGray
        buttonShuffle.alpha = 0.5
        buttonShuffle.translatesAutoresizingMaskIntoConstraints = false
        buttonShuffle.addTarget(self, action: #selector(shuffleTrack(_:)), for: .touchUpInside)
        return buttonShuffle
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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupButtonBack()
    }
    
    //MARK: - Methods
    @objc func shuffleTrack(_ sender: UIButton) {
        countSong = storage.firstIndex(where:{ $0.urlSong == player.url?.path }) ?? 0
        sender.isSelected.toggle()
        if sender.isSelected == true {
            sender.tintColor = .white
            sender.alpha = 1
        } else {
            sender.tintColor = .lightGray
            sender.alpha = 0.5
        }
    }
    @objc func presentActivity(_ sender: UIButton) {
        let content = "Смотри что я нашел - \(labelNameArtist.text!)" + "-" + "\(labelNameSongs.text!)"
        let image = imageAlbum.image!
        let devUrl = URL(string: "https://github.com/shvie")!
        let vc = UIActivityViewController(activityItems: [devUrl, content,image], applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
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
        
        countSong -= 1
        fade(player: player, fromVolume: 1, toVolume: 0, overTime: 2)
        if countSong < 0 {
            countSong = storage.count - 1
        }
        player(elementForPlay: storage[countSong])
    }
    
    //Действие для кнопки дальше в плеере
    @objc func pressSelectedButton() {
        countSong += 1
        fade(player: player, fromVolume: 1, toVolume: 0, overTime: 2)
        if countSong == storage.count {
            countSong = 0
        }
        player(elementForPlay: storage[countSong])
    }
    
    //Действие для кнопки паузы в плеере
    @objc func pressPauseButton() {
        if player.isPlaying == true {
            buttonPaused.isSelected.toggle()
            fade(player: player, fromVolume: 1, toVolume: 0, overTime: 2)
            player.pause()
        } else {
            buttonPaused.isSelected.toggle()
            fade(player: player, fromVolume: 0, toVolume: 1, overTime: 2)
            player.play()
        }
    }
    //таймер для отслеживания времени трека
    @objc func updateTimer() {
        durationSlider.value = Float(player.currentTime)
        
        let remainingTime = player.duration - player.currentTime
        labelCurrentTimeDuration.text = player.currentTime.getFormattedTime()
        labelEndTimeDuration.text = "\(remainingTime.getFormattedTime())"
        if remainingTime == 0 {
            pressSelectedButton()
        }
    }
    //включение выбранного трека
    func player(elementForPlay: Song){
        imageAlbum.image = elementForPlay.image
        labelNameSongs.text = elementForPlay.nameSong
        labelNameArtist.text = elementForPlay.artist
        let url = URL(fileURLWithPath: elementForPlay.urlSong)
        do {
            if player.isPlaying == false {
                buttonPaused.isSelected.toggle()
            }
            player = try AVAudioPlayer(contentsOf: url)
            durationSlider.maximumValue = Float(player.duration)
            fade(player: player, fromVolume: 0, toVolume: 1, overTime: 2)
            player.play()
            
            
        } catch {
            print(error)
        }
    }
    func fade(player: AVAudioPlayer,
              fromVolume startVolume : Float,
              toVolume endVolume : Float,
              overTime time : Float) {
        
        //обновляем громкость 1/100 раз в секунду
        let fadeSteps : Int = Int(time) * 100
        // Определяем, сколько времени займет каждый шаг
        let timePerStep : Double = 1 / 100.0
        
        self.player.volume = startVolume
        
        for step in 0...fadeSteps {
            
            let delayInSeconds : Double = Double(step) * timePerStep
            
            let deadline = DispatchTime.now() + delayInSeconds
            
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                let fraction = (Float(step) / Float(fadeSteps))
                
                player.volume = startVolume + (endVolume - startVolume) * fraction
            })
            
        }
    }
    
    //MARK: - CONSTRAINTS
    
    func setupButtonBack() {
        //Add SubViewsElements
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
        self.view.addSubview(buttonShusffle)
        
        NSLayoutConstraint.activate([
            //      Constraints for stackView
            stackView.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 40),
            //stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            //      Constraints for "sliderDuration"
            durationSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            durationSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            durationSlider.topAnchor.constraint(equalTo: labelNameArtist.bottomAnchor, constant: 20),
            
            
            //Constraints for "labelEndTimeDuration"
            labelEndTimeDuration.rightAnchor.constraint(equalTo: durationSlider.rightAnchor),
            labelEndTimeDuration.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 2),
            
            //      Constraints for "imageAlbum"
            imageAlbum.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageAlbum.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            imageAlbum.heightAnchor.constraint(equalToConstant: sqrt(self.view.frame.size.width * self.view.frame.size.height) / 2),
            imageAlbum.widthAnchor.constraint(equalTo: imageAlbum.heightAnchor),
            
            //      Constraints for "labelNameArtist"
            labelNameArtist.topAnchor.constraint(equalTo: labelNameSongs.bottomAnchor, constant: 10),
            labelNameArtist.leftAnchor.constraint(equalTo: durationSlider.leftAnchor),
            labelNameArtist.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            //      Constraints for "labelCurrentTimeDuration"
            labelCurrentTimeDuration.leftAnchor.constraint(equalTo: durationSlider.leftAnchor),
            labelCurrentTimeDuration.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 2),
            
            //      Constraints for "labelNameSongs"
            labelNameSongs.topAnchor.constraint(equalTo: imageAlbum.bottomAnchor, constant: 20),
            labelNameSongs.leftAnchor.constraint(equalTo: durationSlider.leftAnchor),
            labelNameSongs.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            //      Constraints for "ButtonRepeat"
            buttonRepeat.heightAnchor.constraint(equalToConstant: sqrt(self.view.frame.height * self.view.frame.width) / 20),
            buttonRepeat.widthAnchor.constraint(equalToConstant: sqrt(self.view.frame.height * self.view.frame.width) / 20),
            buttonRepeat.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 25),
            buttonRepeat.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -20 ),
            
            //      Constraints for "ButtonShareActivity"
            buttonShareActivity.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            buttonShareActivity.heightAnchor.constraint(equalToConstant: sqrt(self.view.frame.height * self.view.frame.width) / 18),
            buttonShareActivity.widthAnchor.constraint(equalToConstant: sqrt(self.view.frame.height * self.view.frame.width) / 20),
            buttonShareActivity.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            
            //      Constraints for "ButtonShuffle"
            buttonShusffle.widthAnchor.constraint(equalToConstant: sqrt(self.view.frame.height * self.view.frame.width) / 19),
            buttonShusffle.heightAnchor.constraint(equalToConstant: sqrt(self.view.frame.height * self.view.frame.width) / 20),
            buttonShusffle.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 25),
            buttonShusffle.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 20)
        ])
    }
}
