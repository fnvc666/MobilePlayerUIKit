import UIKit

struct Track {
    let title: String
    let artist: String
    let duration: String
    let imageName: String
    let explicit: Bool
}

class ViewController: UIViewController {
    
    let stackView = UIStackView()
    let myMix = UILabel()
    
    var tracks: [Track] = [
        Track(title: "Afterglow", artist: "N_Bespalov", duration: "3:08", imageName: "afterglowimg", explicit: false),
            Track(title: "Танцуй сама", artist: "Скриптонит", duration: "2:14", imageName: "tanc", explicit: true),
            Track(title: "More", artist: "Lou Rebecca", duration: "3:50", imageName: "restless", explicit: false),
            Track(title: "6 Man", artist: "Drake", duration: "2:46", imageName: "6man", explicit: true),
            Track(title: "Koster", artist: "Soft Blade", duration: "3:07", imageName: "kosterimg", explicit: false),
            Track(title: "Where This Flower Blooms", artist: "Tyler, the Creator", duration: "3:15", imageName: "TylertheCreator", explicit: true)
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 58/255, green: 64/255, blue: 90/255, alpha: 1.0)
        
        configurateStackView()
        
        for(index, track) in tracks.enumerated() {
            let trackView = createTrackView(for: track)
            trackView.tag = index
            stackView.addArrangedSubview(trackView)
        }
        
    }
    
    
    // MARK: - Configurate StackView
    func configurateStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)

        ])
    }
    
    
    func createTrackView(for track: Track) -> UIView {
        let trackView = UIView()
        trackView.backgroundColor = UIColor(red: 174/255, green: 197/255, blue: 235/255, alpha: 1.0)

        trackView.layer.cornerRadius = 10
        trackView.layer.masksToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.text = track.title
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let artistLabel = UILabel()
        artistLabel.text = track.artist
        artistLabel.font = UIFont.boldSystemFont(ofSize: 12)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false

        let durationLabel = UILabel()
        if track.explicit {
            durationLabel.text = "🄴  " + track.duration
        } else {
            durationLabel.text = "" + track.duration
        }
        durationLabel.font = UIFont.systemFont(ofSize: 16)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(named: track.imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        trackView.addSubview(titleLabel)
        trackView.addSubview(artistLabel)
        trackView.addSubview(durationLabel)
        trackView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor, constant: 10),

            imageView.widthAnchor.constraint(equalToConstant: 60),

            imageView.heightAnchor.constraint(equalToConstant: 60),

            imageView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),

            imageView.bottomAnchor.constraint(equalTo: trackView.bottomAnchor, constant: -10),

            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),

            titleLabel.centerYAnchor.constraint(equalTo: trackView.centerYAnchor, constant: -10),
            
            titleLabel.trailingAnchor.constraint(equalTo: trackView.trailingAnchor, constant: -75),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            artistLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),

            durationLabel.trailingAnchor.constraint(equalTo: trackView.trailingAnchor, constant: -20),

            durationLabel.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(trackViewTapped(_:)))
        trackView.addGestureRecognizer(tapGesture)
        trackView.isUserInteractionEnabled = true
        
        
        return trackView
    }
    
    @objc func trackViewTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedTrackView = sender.view else { return }
        
        let trackIndex = tappedTrackView.tag
        
        let playerViewController = PlayerViewController()
        playerViewController.tracks = tracks
        playerViewController.currentIndex = trackIndex
        
        playerViewController.modalPresentationStyle = .pageSheet
        present(playerViewController, animated: true, completion: nil)
    }
}
