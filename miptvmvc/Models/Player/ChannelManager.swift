//
//  ChannelManager.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 05-03-22.
//

import Foundation

protocol ChannelManagerDelegate {
    func didUpdateChannel(_ channelManager: ChannelManager, channels: Channel)
    func didFailWithError()
}

struct ChannelManager {
    var delegate: ChannelManagerDelegate?
    
    let extInfPrefix = "#EXTINF:"
    let idRegex: RegularExpression = #"tvg-id=\"(.?|.+?)\""#
    let nameRegex: RegularExpression = #"tvg-name=\"(.?|.+?)\""#
    let countryRegex: RegularExpression = #"tvg-country=\"(.?|.+?)\""#
    let logoRegex: RegularExpression = #"tvg-logo=\"(.?|.+?)\""#
    let channelNumberRegex: RegularExpression = #"tvg-chno=\"(.?|.+?)\""#
    
    func fetchChannels(with: String){
        self.performRequest(with: with)
    }
    
    func performRequest(with urlString: String){
        // create url
        if let url = URL(string: urlString) {
            // create a URLSession
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = TimeInterval(K.Api.Channels.timeout)
            configuration.timeoutIntervalForResource = TimeInterval(K.Api.Channels.timeout)
            let session = URLSession(configuration: configuration)
            // Give the session task
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError()
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.delegate?.didFailWithError()
                    return
                }
                
                if let safeData = data {
                    if let channels = self.parseM3U(contentsOfFile: String(decoding: safeData, as: UTF8.self)) {
                        
                        self.delegate?.didUpdateChannel(self, channels: channels)
                    }
                }
            }
            // Start the task
            task.resume()
        }
    }
    
    func parseM3U(contentsOfFile: String) -> Channel? {
        var channelItems = [ChannelItem]()
        contentsOfFile.enumerateLines(invoking: { line, stop in
            if line.hasPrefix(extInfPrefix) {
                let infos = Array(line.components(separatedBy: ","))
                var channel = ChannelItem(id: 0, name: infos[1], logo: "", url: "")
                
                if let channelNumber = channelNumberRegex.firstMatch(in: infos[0]) {
                    channel.id = Int(channelNumber)!
                } else if let channelId = idRegex.firstMatch(in: infos[0]) {
                    channel.id = Int(channelId)!
                }
                
                if let channelLogo = logoRegex.firstMatch(in: infos[0]) {
                    channel.logo = channelLogo
                }
                
                if let channelName = nameRegex.firstMatch(in: infos[0]) {
                    channel.name = channelName
                }
                channelItems.append(channel)
                
            } else {
                if var channelItem = channelItems.popLast() {
                    channelItem.url = line
                    channelItems.append(channelItem)
                }
            }
        })
        let channels = Channel(list: channelItems)
        return channels
    }
    
}
