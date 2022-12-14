//
//  PlayerViewController.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 04-03-22.
//

import UIKit
import AVFoundation
import FirebaseAnalytics

class PlayerViewController: UIViewController {
    
    let notificationCenter = NotificationCenter.default
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.style = .large
        ai.tintColor = K.Colors.selectedChannel
        return ai
    }()
    
    let player: AVPlayer = {
        let av = AVPlayer(playerItem: nil)
        return av
    }()
    
    var playerLayer: AVPlayerLayer!
    
    private let playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let controllersView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.Colors.playerControllersBackground
        return view
    }()
    
    private let channelTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChannelCellView.self, forCellReuseIdentifier: K.cellIdentifier)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()

    var channelManager = ChannelManager()
    var channels = [ChannelItem]()
    var unFilteredChannels = [ChannelItem]()
    
    var timer = Timer()
    var secondsPassed = K.Player.timerInitialSeconds
    let totalTime = K.Player.timerInactiveTime
    
    var lastPlayedChannel = IndexPath()
    var playListUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        channelManager.delegate = self
        channelTableView.delegate = self
        channelTableView.dataSource = self
        playerView.addSubview(activityIndicator)
                
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        playerView.layer.addSublayer(playerLayer)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        gesture.delegate = self
        gesture.numberOfTapsRequired = K.Player.gestureNumberOfTapsRequired
        view.addGestureRecognizer(gesture)
        
        controllersView.addSubview(channelTableView)
        
        view.addSubview(playerView)
        view.addSubview(controllersView)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.controllersView.isHidden = true
        Utils.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        lastPlayedChannel = IndexPath(row: Utils.getLastPlayedChannel() ?? 0, section: 0)
        playListUrl = Utils.getUserPlayList()!
        self.loadChannels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopContent()
        Utils.lockOrientation(.portrait, andRotateTo: .portraitUpsideDown)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = playerView.bounds
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            if #available(iOS 10.0, *) {
                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                if newStatus != oldStatus {
                    DispatchQueue.main.async {[weak self] in
                        if newStatus == .playing {
                            self?.activityIndicator.stopAnimating()
                        } else {
                            self?.activityIndicator.startAnimating()
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        toggleControllers()
    }
    
    @objc func appMovedToBackground() {
        stopContent()
    }
    
    @objc func appBecomeActive() {
        playContent(indexPath: self.lastPlayedChannel)
    }
    
    private func setupView(){
        var constraints = [NSLayoutConstraint]()
        
        //add
        constraints.append(activityIndicator.centerYAnchor.constraint(equalTo: playerView.centerYAnchor))
        constraints.append(activityIndicator.centerXAnchor.constraint(equalTo: playerView.centerXAnchor))
        
        constraints.append(playerView.heightAnchor.constraint(equalTo: view.heightAnchor))
        constraints.append(playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        
        constraints.append(controllersView.heightAnchor.constraint(equalTo: view.heightAnchor))
        constraints.append(controllersView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: K.Player.controllersViewSizeMultiplier))
        
        constraints.append(channelTableView.topAnchor.constraint(equalTo: controllersView.topAnchor))
        constraints.append(channelTableView.bottomAnchor.constraint(equalTo: controllersView.bottomAnchor))
        constraints.append(channelTableView.widthAnchor.constraint(equalTo: controllersView.widthAnchor))
        //activate
        NSLayoutConstraint.activate(constraints)
    }
    
    private func loadChannels() {
        activityIndicator.startAnimating()
        channelManager.fetchChannels(with: playListUrl)
    }
    
    private func toggleControllers() {
        let isHidden = controllersView.isHidden
        
        if (!lastPlayedChannel.isEmpty && channels.count > 0) {
            
            if (isHidden) {
                self.selectCellChannel(indexPath: lastPlayedChannel)
                startTimer()
            } else {
                stopTimer()
            }
            self.controllersView.isHidden = !isHidden
            self.navigationController?.setNavigationBarHidden(!isHidden, animated: false)
        }
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
        } else {
            toggleControllers()
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer.invalidate()
        secondsPassed = K.Player.timerInitialSeconds
        timer = Timer.scheduledTimer(timeInterval: K.Player.timerTimeInterval, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer.invalidate()
        secondsPassed = 0
    }
    
    private func playContent(indexPath: IndexPath) {
        if lastPlayedChannel != indexPath {
            let ch = self.channels[indexPath.row]
            self.player.pause()
            self.player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: ch.url)!))
            self.player.play()
            lastPlayedChannel = indexPath
            Utils.setLastPlayedChannel(row: lastPlayedChannel.row)
            
            Analytics.logEvent(K.TagManager.PlayContent.varName, parameters: [
                K.TagManager.PlayContent.eventParameter.channel: ch.name,
                K.TagManager.CommonEventParameter.username: Utils.getUsername()!
            ])
        }
    }
    
    private func stopContent(){
        stopTimer()
        player.pause()
        player.replaceCurrentItem(with: nil)
    }
    
    private func selectCellChannel(indexPath: IndexPath) {
        if channels.indices.contains(indexPath.row) {
            channelTableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
        }
    }
}

//MARK: - ChannelManagerDelegate

extension PlayerViewController: ChannelManagerDelegate {
    func didUpdateChannel(_ channelManager: ChannelManager, channels: Channel) {
        DispatchQueue.main.async {
            self.channels = channels.list.sorted(by: { $0.name < $1.name })
            self.channelTableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.playContent(indexPath: self.lastPlayedChannel)
        }
    }
    
    func didFailWithError() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Oops!", message: "Error al intentar cargar la lista de canales", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                self.loadChannels()
            }))
            self.present(alert, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource

extension PlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = channelTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ChannelCellView
        
        cell.configure(model: channels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
}

//MARK: - UITableViewDelegate

extension PlayerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.playContent(indexPath: indexPath)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        stopTimer()
        startTimer()
    }
}

//MARK: - UIGestureRecognizerDelegate

extension PlayerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let isControllTapped = touch.view?.isDescendant(of: self.channelTableView)
        return !isControllTapped!
    }
}
