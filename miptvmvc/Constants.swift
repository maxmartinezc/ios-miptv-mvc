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
    
    struct Login {
        static let labelTitleFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let labelErrorFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
        static let buttonCornerRadius = CGFloat(12)
        static let buttonBorderWidth = CGFloat(1)
        
        static let textFieldCornerRadius = CGFloat(12)
        static let textFieldBorderWidth = CGFloat(1)
        static let textFieldLeftViewWidth = CGFloat(5)
        static let textFieldLeftViewHeight = CGFloat(0)
        static let textFieldLeftViewX = CGFloat(0)
        static let textFieldLeftViewY = CGFloat(0)
        
        static let hStackSpacing = CGFloat(10)
        static let hStackViewTopAnchor = CGFloat(10)
        static let hStackViewLeadingAnchor = CGFloat(20)
        static let hStackViewTrailingAnchor = CGFloat(-20)
        
        static let appLogoImageViewTopAnchor = CGFloat(10)
        static let appLogoImageViewWidthAnchor = CGFloat(250)
        static let appLogoImageViewHeightAnchor = CGFloat(250)
        
        static let loginLabelTopAnchor = CGFloat(15)
        static let loginLabelHeightAnchor = CGFloat(30)
        
        static let userFieldHeightAnchor = CGFloat(50)
        static let passwordFieldHeightAnchor = CGFloat(50)
        static let loginButtonHeightAnchor = CGFloat(60)
        static let userLabelErrorHeightAnchor = CGFloat(10)
        static let passwordLabelErrorHeightAnchor = CGFloat(10)
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
        
        static let controllersViewSizeMultiplier = CGFloat(0.35)
        
        static let timerInactiveTime = 10
        static let timerTimeInterval = CGFloat(1.0)
        static let timerInitialSeconds = 0
        
        static let gestureNumberOfTapsRequired = 1
    }
    
    struct Popup {
        static let viewCornerRadius = CGFloat(12)
        static let viewBorderWidth = CGFloat(1)
        
        static let buttonCornerRadius = CGFloat(12)
        static let buttonBorderWidth = CGFloat(1)
        
        static let labelTitleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let labelMessageFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let labelMessageNumberOfLines = 0
        
        static let contentViewWidthAnchor = CGFloat(50)
        static let contentViewBottomAnchor = CGFloat(20)
        static let titleLabelTopAnchor = CGFloat(10)
        static let messageLabelTopAnchor = CGFloat(50)
        
        static let buttonTopAnchor = CGFloat(20)
        static let buttonWidthAnchor = CGFloat(100)
        
        static let animationDuration = CGFloat(0.25)
    }
    
    struct Loading {
        static let spinninCircleViewWidthAnchor = CGFloat(100)
        static let spinninCircleViewHeightAnchor = CGFloat(100)
        
        static let spinningCircleLineWidth = CGFloat(10)
        static let spinningCircleStrokeEnd = CGFloat(0.25)
        
        static let spinningCircleFrameX = CGFloat(0)
        static let spinningCircleFrameY = CGFloat(0)
        static let spinningCircleFrameWidth = CGFloat(100)
        static let spinningCircleFrameHeight = CGFloat(100)
        
        
        static let spinningCircleAnimationDuration = CGFloat(1)
        static let spinningCircleAnimationDelay = CGFloat(0)
        static let spinningCircleRotationAngle = CGFloat(0)
    }
    
    struct Colors {
        static let alertTitle = UIColor.black
        static let alertMessage = UIColor.black
        static let alertContentBackground = UIColor.white
        static let alertBackground = UIColor.black.withAlphaComponent(0.8)
        static let background = UIColor(red: 83/255.0, green: 62/255.0, blue: 133/255.0, alpha: 1)
        static let loadingBackground = UIColor(red: 83/255.0, green: 62/255.0, blue: 133/255.0, alpha: 0.8)
        static let button = UIColor(red: 79/255.0, green: 211/255.0, blue: 196/255.0, alpha: 1)
        static let title = UIColor.white
        static let menuBackground = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
        
        static let selectedChannel = UIColor.white
        static let favoriteChannelIcon = UIColor.white
        static let selectedChannelBoxBackground = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
        
        static let defaultChannelNameTextColor = UIColor.lightGray
        static let defualtChannelImageBackgroundColor = UIColor.clear
        static let defaultChannelBoxBackground = UIColor.clear
        
        static let playerControllersBackground = UIColor.black.withAlphaComponent(0.7)
    }
}
