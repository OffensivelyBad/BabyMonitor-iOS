//
//  FeedViewController.swift
//  BabyMonitor
//
//  Created by Shawn Roller on 9/17/17.
//  Copyright © 2017 OffensivelyBad. All rights reserved.
//

import UIKit
import SafariServices

class FeedViewController: UIViewController {

    let kMonitorURL = "http://192.168.1.56/html/index.php"
    let kArchiveURL = "http://192.168.1.56/html/preview.php"
    let kAudioURL = "http://192.168.1.56:8000/raspi.m3u"
    let kLightsOnURL = "http://192.168.1.56:8080/lightsOn"
    let kLightsOffURL = "http://192.168.1.56:8080/lightsOff"
    
    @IBOutlet weak var motionButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    @IBOutlet weak var archiveButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    // Web views
    var webView: SFSafariViewController!
    var audioWebView = UIWebView()
    
    var showingArchive = false
    var lightsOn = false
    var motionOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        setupWebView()
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
            
        }
        else {
            self.archiveButton.setTitle("Live Feed", for: .normal)
            
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
        guard let url = URL(string: self.kMonitorURL) else { return }
        // Add the webview
        self.webView = SFSafariViewController(url: url)
        self.webView.view.frame = self.containerView.frame
        self.webView.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.webView)
        self.containerView.addSubview(self.webView.view)
        self.webView.didMove(toParentViewController: self)
        
        // Constrain the webview
        self.webView.view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        self.webView.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        self.webView.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        self.webView.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        
        // Round the corners
        self.containerView.layer.cornerRadius = 6
        self.containerView.layer.masksToBounds = true
        
    }
    
}

//MARK: - Audio
extension FeedViewController {
    
    func startAudioStream() {
        guard let url = URL(string: self.kAudioURL) else {
            showAlert(title: "Error", message: "Could not start audio")
            return
        }
        let request = URLRequest(url: url)
//        self.audioWebView.load(request)
    }
    
}
