//
//  LoginManager.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 28-03-22.
//

import Foundation

protocol LoginManagerDelegate {
    func didUpdateLogin(_ loginManager: LoginManager, userData: UserModel)
    func didFailWithError(error: Error)
}

struct LoginManager {
    var delegate: LoginManagerDelegate?
    
    func login(user: String, password: String){
//        self.delegate?.didUpdateLogin(self, userData: UserModel(firstName: "Max", lastName: "Martinez", playListUrl: "https://m3u.cl/lista/chileiptv.m3u"))
        
        self.performRequest(user: user, password: password)
    }
    
    func performRequest(user: String, password: String){
        // create url
        if let url = URL(string: K.Api.Login.url) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = K.Api.Login.method
            urlRequest.timeoutInterval = Double(K.Api.Login.timeout)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let parameters: [String: Any] = [
                "username": user,
                "password": password
            ]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            
            urlRequest.httpBody = httpBody
            // create a URLSession
            let session = URLSession(configuration: .default)
            // Give the session task
            let task = session.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data, let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 400...599:
                        if let errorStatus = self.parseJSONError(safeData) {
                            let err: ApiError
                            switch errorStatus.error {
                            case "USER_OR_PASSWORD_NOT_VALID":
                                err = ApiError.invalidUserOrPassword(error: errorStatus)
                            case "SCHEMA_NOT_VALID":
                                err = ApiError.badRequest(error: errorStatus)
                            default:
                                err = ApiError.internalServerError(error: errorStatus)
                            }
                            self.delegate?.didFailWithError(error: err)
                        }
                    case 200...299:
                        if let response = self.parseJSONSuccess(safeData) {
                            self.delegate?.didUpdateLogin(self, userData: response)
                        }
                    default:
                        break
                    }
                }
            }
            // Start the task
            task.resume()
        }
    }
    
    private func parseJSONError(_ responseData: Data) -> ErrorResponse? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(ErrorResponse.self, from: responseData)
            return decodeData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    private func parseJSONSuccess(_ responseData: Data) -> UserModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(LoginResponse.self, from: responseData)
            let user = UserModel(firstName: decodeData.firstName, lastName: decodeData.lastName, playListUrl: decodeData.playList)
            return user
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
