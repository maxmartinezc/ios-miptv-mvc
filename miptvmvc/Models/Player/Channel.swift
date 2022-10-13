//
//  ChannelModel.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 06-03-22.
//

struct Channel: Codable {
    let list: [ChannelItem]
}

struct ChannelItem: Codable {
    var id: Int
    var name: String
    var logo: String
    var url: String
    var isFavorite: Bool = false
}
