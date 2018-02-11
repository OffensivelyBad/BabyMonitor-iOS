//
//  FeedViewController.swift
//  BabyMonitor
//
//  Created by Shawn Roller on 9/17/17.
//  Copyright © 2017 OffensivelyBad. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class FeedViewController: UIViewController {

    let kMonitorURL = "http://192.168.1.56/html/cam_pic_new.php"
    let kArchiveURL = "http://192.168.1.56/html/preview.php"
    let kAudioURL = "http://192.168.1.56:8000/raspi.m3u"
    let kLightsOnURL = "http://192.168.1.56:8080/lightsOn"
    let kLightsOffURL = "http://192.168.1.56:8080/lightsOff"
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var motionButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var archiveButton: UIButton!
    
    var showingArchive = false
    var lightsOn = false
    var motionOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        configureButtons()
        
        startAudioStream()
        
    }

    func configureButtons() {
    
        
        
    }
    
    @IBAction func motionTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func lightTapped(_ sender: Any) {
        
        if self.lightsOn {
            self.lightButton.setTitle("Light On", for: .normal)
            sendRequest(to: self.kLightsOffURL)
        }
        else {
            self.lightButton.setTitle("Light Off", for: .normal)
            sendRequest(to: self.kLightsOnURL)
        }
        
        self.lightsOn = !self.lightsOn
        
    }
    
    @IBAction func archiveTapped(_ sender: Any) {
        
        if self.showingArchive {
            self.archiveButton.setTitle("Archive", for: .normal)
            loadURL(kMonitorURL)
        }
        else {
            self.archiveButton.setTitle("Live Feed", for: .normal)
            loadURL(kArchiveURL)
        }
        
        self.showingArchive = !self.showingArchive
        
    }
    
    
}

// MARK: - HTTP request
extension FeedViewController {
    
    func sendRequest(to urlString: String) {
        let url = URL(string: urlString)
        guard let theURL = url else { return }
        let task = URLSession.shared.dataTask(with: theURL) { data, response, error in
            guard error == nil else {
                self.showAlert(title: "Error", message: "Could not process the request")
                return
            }
        }
        task.resume()
    }
    
}

// MARK: Alerts
extension FeedViewController {
    
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Tappers
extension FeedViewController {

    
    
    
}

//MARK: - WebKitView
extension FeedViewController {
    
    func setupWebView() {
        
        // Round the corners
        self.webView.layer.cornerRadius = 6
        self.webView.layer.masksToBounds = true
        
        // Create the html request
        loadURL(self.kMonitorURL)
        
    }
    
    func loadURL(_ requestedURL: String) {
        
        // Create the html request
        guard let url = URL(string: requestedURL) else { return }
        let request = URLRequest(url: url)
        self.webView.load(request)
        
    }
    
}

//MARK: - Audio
extension FeedViewController {
    
    func startAudioStream() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard let url = URL(string: self.kAudioURL) else {
            showAlert(title: "Error", message: "Can't start audio stream")
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        player.play()
    }
    
}
