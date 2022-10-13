//
//  PlayerViewController.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 04-03-22.
//

import UIKit
import AVFoundation

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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
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
    
    private let filterView: FilterView = {
        let view = FilterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var channelManager = ChannelManager()
    var channels = [ChannelItem]()
    var unFilteredChannels = [ChannelItem]()
    
    var timer = Timer()
    var secondsPassed = 0
    let totalTime = 10
    
    var lastPlayedChannel = IndexPath()
    var playListUrl = String()
    var userFavorite = Favorite(list: [FavoriteItem]())
    
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
        
        channelTableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:))))
        
        filterView.favoriteButton.addTarget(self, action: #selector(handleFavoriteButtonPress), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        gesture.delegate = self
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
        
        controllersView.addSubview(filterView)
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
        if let safeUserFavoriteDate = Utils.getUserFavorites() {
            self.userFavorite = safeUserFavoriteDate
        }
        self.loadChannels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Utils.setUserFavorites(data: userFavorite)
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
        print("checkAction")
        toggleControllers()
    }
    
    @objc func appMovedToBackground() {
        stopContent()
    }
    
    @objc func appBecomeActive() {
        playContent(indexPath: self.lastPlayedChannel)
    }
    
    @objc func handleFavoriteButtonPress(sender: UIButton) {

        sender.isSelected = !sender.isSelected

        if sender.isSelected == false {
            channels = unFilteredChannels
            channelTableView.reloadData()
            self.selectCellChannel(indexPath: lastPlayedChannel)
        } else {
            channels = unFilteredChannels.filter { $0.isFavorite == sender.isSelected }
            channelTableView.reloadData()
        }
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {

        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: channelTableView)
            if let indexPath = channelTableView.indexPathForRow(at: touchPoint) {
                
                let chId = channels[indexPath.row].id
                let channelItemIndex = unFilteredChannels.firstIndex(where: { $0.id == chId })!
                
                channels[indexPath.row].isFavorite = !channels[indexPath.row].isFavorite
                unFilteredChannels[channelItemIndex] = channels[indexPath.row]
                channelTableView.reconfigureRows(at: [indexPath])
            }
        }
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
        constraints.append(controllersView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35))
        
        constraints.append(filterView.heightAnchor.constraint(equalToConstant: 50))
        constraints.append(filterView.bottomAnchor.constraint(equalTo: controllersView.bottomAnchor))
        // quitar esta linea, es solo para probar
        constraints.append(filterView.leadingAnchor.constraint(equalTo: channelTableView.trailingAnchor, constant: -10))

        constraints.append(channelTableView.topAnchor.constraint(equalTo: controllersView.topAnchor, constant: 50))
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
        secondsPassed = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer.invalidate()
        secondsPassed = 0
    }
    
    private func playContent(indexPath: IndexPath) {
        let ch = self.channels[indexPath.row]
        self.player.pause()
        self.player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: ch.url)!))
        self.player.play()
        lastPlayedChannel = indexPath
        Utils.setLastPlayedChannel(row: lastPlayedChannel.row)
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
            self.unFilteredChannels = channels.list.sorted(by: { $0.name < $1.name })
            for index in self.unFilteredChannels.indices {
                let isFavorite: Bool
                if let _ = self.userFavorite.list.firstIndex(where: { $0.id == self.unFilteredChannels[index].id }) {
                    isFavorite = true
                } else {
                    isFavorite = false
                }
                self.unFilteredChannels[index].isFavorite = isFavorite
            }
            
            self.channels = self.unFilteredChannels
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

extension PlayerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let isControllTapped = touch.view?.isDescendant(of: self.channelTableView)
        return !isControllTapped!
    }
}

