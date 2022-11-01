# Miptv
| Sigin  | Watching | Channels  | About | TagManager |
| ------ | -------- | --------- | ----- | ---------- |
|<img src="https://github.com/maxmartinezc/ios-miptv-mvc/blob/master/Docs/signin-screen.png" width="250" heigth="250"/>|<img src="https://github.com/maxmartinezc/ios-miptv-mvc/blob/master/Docs/watching-screen.png" width="350" heigth="350"/>|<img src="https://github.com/maxmartinezc/ios-miptv-mvc/blob/master/Docs/channel-list-screen.png" width="350" heigth="350"/>|<img src="https://github.com/maxmartinezc/ios-miptv-mvc/blob/master/Docs/about-screen.png" width="350" heigth="350"/>|<img src="https://github.com/maxmartinezc/ios-miptv-mvc/blob/master/Docs/ga-screen.png" width="350" heigth="350"/>|

Miptv application to watching iptv from m3u list

# Features
- User signin
- Play m3u list
- Last played channel
- Switch channels
- Firebase/TagManager

# Architecture
- MVC
- Swift 5
- No Storyboard, no XIB.
- URLSession
- Cocoapods

## Minimun deployments
- iOS 15.0

## Local Server
- Open mockoon
- Load mockoon.json
- Start server

## Login
The available users bellow:
- user1@mail.com (Success - http status 200 - example m3u list 1)
- user2@mail.com (Success - http status 200 - example m3u list 2)
- user3@mail.com (Internal Server Error - http status 500)
- user4@mail.com (Bad request - http status 400)

* All users has the password: *123456*

TV Logo credits by: <a href="https://www.vecteezy.com/free-vector/tv-logo" target="_blank">Tv Logo Vectors by Vecteezy</a>
