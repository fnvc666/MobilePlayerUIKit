import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    var tracks: [Track] = []
    var currentIndex = 0
    var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    var sliderTimer: Timer?
    
    // MARK: - UI Elements
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let trackSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .lightGray
        let imageThumb = UIImage(systemName: "circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 10))
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        slider.setThumbImage(imageThumb, for: .normal)
        slider.minimumValue = 0
        slider.maximumValue = 1.0
        slider.setValue(0.5, animated: true)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "play.circle.fill")
        configuration.imagePadding = 10
        configuration.baseForegroundColor = .white
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 40)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "forward.end.fill")
        configuration.baseForegroundColor = .white
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let previousButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "backward.end.fill")
        configuration.baseForegroundColor = .white
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let closeSwipe: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.baseForegroundColor = .white
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isSymbolAnimationEnabled = true
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "square.and.arrow.up")
        configuration.baseForegroundColor = .white
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let volumeMin: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "speaker.minus.fill")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let volumeMax: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "speaker.plus.fill")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .lightGray
        let imageThumbVolume = UIImage(systemName: "circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 10))
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        slider.setThumbImage(imageThumbVolume, for: .normal)
        slider.minimumValue = 0
        slider.maximumValue = 1.0
        slider.setValue(0.2, animated: true)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "0:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let remamingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "-0:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 58/255, green: 64/255, blue: 90/255, alpha: 1.0)
        
        setupUI()
        setupActions()
        updateTrackInfo()
    }
    
    // MARK: - Setup interface
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(closeSwipe)
        view.addSubview(shareButton)
        view.addSubview(trackView)
        
        trackView.addSubview(imageView)
        trackView.addSubview(mainTitleLabel)
        trackView.addSubview(artistLabel)
        trackView.addSubview(trackSlider)
        trackView.addSubview(currentTimeLabel)
        trackView.addSubview(remamingTimeLabel)
        trackView.addSubview(playButton)
        trackView.addSubview(nextButton)
        trackView.addSubview(previousButton)
        trackView.addSubview(volumeMin)
        trackView.addSubview(volumeMax)
        trackView.addSubview(volumeSlider)
        
        setupConstraints()
    }
    
    func setupActions() {
        playButton.addTarget(self, action: #selector(playTrack), for: .touchUpInside)
        
        nextButton.addTarget(self, action: #selector(changeToNextTrack), for: .touchUpInside)

        previousButton.addTarget(self, action: #selector(changeToPreviousTrack), for: .touchUpInside)
        
        trackSlider.addTarget(self, action: #selector(trackSliderValue), for: .valueChanged)
        
        volumeSlider.addTarget(self, action: #selector(volumeSliderValueChanged(_:)), for: .valueChanged)
        
        closeSwipe.addTarget(self, action: #selector(closeSwipeClick), for: .touchUpInside)
        
        shareButton.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
        
    }
    
    func updateTrackInfo() {
        let currentTrack = tracks[currentIndex]
        titleLabel.text = currentTrack.title
        mainTitleLabel.text = currentTrack.title
        artistLabel.text = currentTrack.artist
        imageView.image = UIImage(named: currentTrack.imageName)
        
        let trackDurationInSeconds = timeStringToSecond(currentTrack.duration)
        
        trackSlider.minimumValue = 0
        trackSlider.maximumValue = Float(trackDurationInSeconds)
        trackSlider.value = Float(audioPlayer?.currentTime ?? 0)
        
        if view.backgroundColor != .clear {
                imageView.image?.getColors { colors in
                    guard let primaryColor = colors?.primary, let backgroundColor = colors?.background else { return }
                    
                    let darkenedColor = backgroundColor.darker(by: 30) ?? .black
                    
                    DispatchQueue.main.async {
                        CATransaction.begin()
                        CATransaction.setCompletionBlock {
                            self.view.backgroundColor = .clear
                        }
                        self.animateInitialBackgroundToGradient(primary: darkenedColor, secondary: primaryColor)
                        CATransaction.commit()
                    }
                }
            } else {
                updateBackgroundColor()
            }
        }
    
    func animateInitialBackgroundToGradient(primary: UIColor, secondary: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [primary.cgColor, secondary.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        gradientLayer.opacity = 0
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.duration = 0.5
        gradientLayer.add(opacityAnimation, forKey: "opacity")
        gradientLayer.opacity = 1
    }

    
    func updateBackgroundColor() {
        guard let image = imageView.image else { return }
        
        image.getColors { colors in
            guard let primaryColor = colors?.primary, let backgroundColor = colors?.background else { return }
            
            let darkenedColor = backgroundColor.darker(by: 50) ?? .black
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    self.setGradientBackground(primary: darkenedColor, secondary: primaryColor)
                    
                }
            }
        }
    }

    
    // MARK: - Set Constraints
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // closeSwipe
            closeSwipe.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeSwipe.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            // shareButton
            shareButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            shareButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // trackView
            trackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            trackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trackView.bottomAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 20),
            
            // imageView
            imageView.topAnchor.constraint(equalTo: trackView.topAnchor, constant: 25),
            imageView.centerXAnchor.constraint(equalTo: trackView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            // mainTitleLabel
            mainTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            mainTitleLabel.leadingAnchor.constraint(equalTo: trackView.leadingAnchor, constant: 25),
            
            // artistLabel
            artistLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 10),
            artistLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            
            // trackSlider
            trackSlider.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 60),
            trackSlider.leadingAnchor.constraint(equalTo: trackView.leadingAnchor, constant: 20),
            trackSlider.trailingAnchor.constraint(equalTo: trackView.trailingAnchor, constant: -20),
            
            // currentTimeLabel
            currentTimeLabel.leadingAnchor.constraint(equalTo: trackSlider.leadingAnchor),
            currentTimeLabel.bottomAnchor.constraint(equalTo: trackSlider.topAnchor, constant: -8),
            
            // remainingTimeLabel
            remamingTimeLabel.trailingAnchor.constraint(equalTo: trackSlider.trailingAnchor),
            remamingTimeLabel.bottomAnchor.constraint(equalTo: trackSlider.topAnchor, constant: -8),
            
            // playButton
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.topAnchor.constraint(equalTo: trackSlider.bottomAnchor, constant: 30),
            playButton.centerXAnchor.constraint(equalTo: trackView.centerXAnchor),
            
            // nextButton
            nextButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            nextButton.centerXAnchor.constraint(equalTo: playButton.centerXAnchor, constant: 100),
            
            // previousButton
            previousButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            previousButton.centerXAnchor.constraint(equalTo: playButton.centerXAnchor, constant: -100),
            
            // volumeMin
            volumeMin.heightAnchor.constraint(equalToConstant: 20),
            volumeMin.widthAnchor.constraint(equalToConstant: 20),
            volumeMin.centerXAnchor.constraint(equalTo: previousButton.centerXAnchor, constant: -10),
            volumeMin.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 50),
            
            // volumeMax
            volumeMax.heightAnchor.constraint(equalToConstant: 20),
            volumeMax.widthAnchor.constraint(equalToConstant: 20),
            volumeMax.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor, constant: 10),
            volumeMax.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 50),
            
            // volumeSlider
            volumeSlider.topAnchor.constraint(equalTo: volumeMax.topAnchor, constant: 4),
            volumeSlider.leadingAnchor.constraint(equalTo: volumeMin.trailingAnchor, constant: 10),
            volumeSlider.trailingAnchor.constraint(equalTo: volumeMax.leadingAnchor, constant: -10),
        ])
    }
    
    // MARK: - Actions
    
    func timeStringToSecond(_ timeString: String) -> TimeInterval {
        let components = timeString.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return 0 }
        let minutes = components[0]
        let seconds = components[1]
        return TimeInterval(minutes * 60 + seconds)
    }
    
    func startSliderTimer() {
        sliderTimer?.invalidate()
        sliderTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self, let audioPlayer = self.audioPlayer else { return }
            
            let currentTime = audioPlayer.currentTime
            let remainingTime = audioPlayer.duration - currentTime
            
            self.trackSlider.value = Float(currentTime)
            
            self.currentTimeLabel.text = self.formatTime(currentTime)
            self.remamingTimeLabel.text = "- " + self.formatTime(remainingTime)
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String{
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func stopSliderTime() {
        sliderTimer?.invalidate()
        sliderTimer = nil
    }
    
    @objc func playTrack() {
        if let audioPlayer = audioPlayer {
            if isPlaying {
                audioPlayer.pause()
                stopSliderTime()
                isPlaying = false
            } else {
                audioPlayer.play()
                startSliderTimer()
                isPlaying = true
            }
        } else {
            let trackName = tracks[currentIndex].title
            guard let url = Bundle.main.url(forResource: trackName, withExtension: "mp3") else {
                print("Can't find \(trackName).mp3")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.volume = volumeSlider.value
                audioPlayer?.play()
                startSliderTimer()
                isPlaying = true
            } catch {
                print("Error of play audio \(error.localizedDescription)")
            }
        }
        updatePlayButtonIcon()
    }
    
    func changeTrack(by offset: Int) {
        currentIndex = (currentIndex + offset + tracks.count) % tracks.count
        audioPlayer?.stop()
        audioPlayer = nil
        updateTrackInfo()
        if isPlaying {
            playTrack()
        } else {
            updatePlayButtonIcon()
        }
    }
    
    @objc func changeToNextTrack() {
        changeTrack(by: 1)
    }
    
    @objc func changeToPreviousTrack() {
        changeTrack(by: -1)
    }
    
    @objc func trackSliderValue(_ sender: UISlider) {
        audioPlayer?.currentTime = TimeInterval(sender.value)
    }
    
    @objc func volumeSliderValueChanged(_ sender: UISlider){
        audioPlayer?.volume = sender.value
    }
    
    @objc func closeSwipeClick() {
        UIView.transition(with: closeSwipe, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.closeSwipe.setImage(UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }, completion: nil)

        UIView.animate(withDuration: 0.25) {
            self.closeSwipe.transform = CGAffineTransform(translationX: 0, y: 10)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    @objc func shareButtonClick() {
        let currentTrack = tracks[currentIndex]
        
        let trackTitle = currentTrack.title
        let trackArtist = currentTrack.artist
        let shareText = "Listen with me: \(trackTitle) \(trackArtist)"
        
        let shareImage = imageView.image
        
        var activityItems: [Any] = [shareText]
        if let image = shareImage {
            activityItems.append(image)
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
    }
    
    func updatePlayButtonIcon() {
        var configurationPlay = UIButton.Configuration.plain()
        configurationPlay.image = UIImage(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
        configurationPlay.imagePadding = 10
        configurationPlay.baseForegroundColor = .white
        configurationPlay.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 40)
        playButton.configuration = configurationPlay
    }
    
    func setGradientBackground(primary: UIColor, secondary: UIColor) {
        if let existingGradient = view.layer.sublayers?.compactMap({ $0 as? CAGradientLayer }).first {
            let colorAnimation = CABasicAnimation(keyPath: "colors")
            colorAnimation.fromValue = existingGradient.colors
            colorAnimation.toValue = [primary.cgColor, secondary.cgColor]
            colorAnimation.duration = 0.5 // Длительность анимации
            existingGradient.colors = [primary.cgColor, secondary.cgColor]
            existingGradient.add(colorAnimation, forKey: "colors")
        } else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [primary.cgColor, secondary.cgColor]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.frame = view.bounds
            
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    
    func randomGradientPoints() -> (startPoint: CGPoint, endPoint: CGPoint) {
        let randomStartX = CGFloat.random(in: 0.3...1)
        let randomStartY = CGFloat.random(in: 0.3...1)
        let randomEndX = CGFloat.random(in: 0.3...1)
        let randomEndY = CGFloat.random(in: 0.3...1)
        
        let startPoint = CGPoint(x: randomStartX, y: randomStartY)
        let endPoint = CGPoint(x: randomEndX, y: randomEndY)
        
        return (startPoint, endPoint)
    }
}
