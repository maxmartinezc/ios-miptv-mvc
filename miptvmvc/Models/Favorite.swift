//
//  Favorite.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 09-10-22.
//

struct Favorite: Codable {
    var list: [FavoriteItem]
    
    mutating func addFavorite(id: Int) {
        list.append(FavoriteItem(id: id))
    }
    mutating func removeFavorite(id: Int) {
        list.remove(at: id)
    }
}

struct FavoriteItem: Codable {
    var id: Int
}
