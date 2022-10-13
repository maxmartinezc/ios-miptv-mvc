//
//  Constants.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 06-03-22.
//

import UIKit

struct K {
    static let appName = "MiPTV"
    static let appLogo = "mitv-logo.png"
    static let loadImage = "mitv-logo.png"
    static let cellIdentifier = "ReusableCell"
    static let menuCellIdentifier = "menuCell"
    
    struct appDeveloper {
        static let name = "Max Martinez Cartagena"
        static let email = "max.martinez.c@gmail.com"
        static let linkedin = "http://www.linkedin.com/in/maxmartinezc"
    }
    
    struct Api {
        struct Login {
            static let url = "http://127.0.0.1:3001/miptv/auth/login"
            static let method = "POST"
            static let timeout = 6
        }
        
        struct Channels {
            static let method = "GET"
            static let timeout = 5
        }
    }

    struct UserConfig {
        static let username = "username"
        static let lastPlayed = "lastPlayedChannelRow"
        static let playList = "myPlaylist"
        static let favoriteList = "favoriteList"
    }
    
    struct Player {
        
        static let cellChannelNameLabelSize = CGFloat(14)
        //constraints
        static let cellChannelTopAnchor = CGFloat(-5)
        static let cellChannelBottomAnchor = CGFloat(-5)
        static let cellChannelHeightAnchor = CGFloat(10)
        static let cellChannelImageWidthAnchor = CGFloat(50)
        static let cellChannelImageHeightAnchor = CGFloat(50)
        static let cellChannelImageLeadingAnchor = CGFloat(5)
        
        static let cellChannelDividerLeadingAnchor = CGFloat(10)
        static let cellChannelDividerTopAnchor = CGFloat(10)
        static let cellChannelDividerHeightAnchor = CGFloat(2)
        
        static let cellChannelNameLeadingAnchor = CGFloat(10)
        static let cellChannelNameWidthAnchor = CGFloat(0.7)
        static let cellChannelFavoriteImageTrailingAnchor = CGFloat(-10)
    }
    
    struct Colors {
        static let alertTitle = UIColor.black
        static let alertMessage = UIColor.black
        static let alertContentBackground = UIColor.white
        static let alertBackground = UIColor.black
        static let background = UIColor(red: 83/255.0, green: 62/255.0, blue: 133/255.0, alpha: 1)
        static let button = UIColor(red: 79/255.0, green: 211/255.0, blue: 196/255.0, alpha: 1)
        static let title = UIColor.white
        static let menuBackground = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
        
        static let selectedChannel = UIColor.white
        static let favoriteChannelIcon = UIColor.white
        static let selectedChannelBoxBackground = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
        
        static let defaultChannelNameTextColor = UIColor.lightGray
        static let defualtChannelImageBackgroundColor = UIColor.clear
        static let defaultChannelBoxBackground = UIColor.clear
    }
}
