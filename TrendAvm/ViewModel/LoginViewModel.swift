//
//  LoginViewModel.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 2.03.2023.
//

import Foundation
import Alamofire

class LoginViewModel {

    var loginResponse = Observable<LoginResponseModel>()
    var isLoading = Observable<Bool>()
    var alertItem = Observable<AlertItem>()
    
    func login(username:String, password:String){
        isLoading.value = true
        
        
        NetworkManager.instance.fetch(endpoint: TrendAvmEndPoint.login(request: LoginRequest(username: username, password: password)), responseModel: LoginResponseModel.self){ [self] result in
            
            DispatchQueue.main.async { [self] in
                isLoading.value = false
                
                switch result {
                case .success(let result):
                    self.loginResponse.value = result
                    
                case .failure(let error):
                    switch error {
                    case .invalidData:
                        alertItem.value = AlertContext.invalidData
                        
                    case .invalidURL:
                        alertItem.value = AlertContext.invalidURL
                        
                    case .invalidResponse:
                        alertItem.value = AlertContext.invalidResponse
                        
                    case .unableToComplete:
                        alertItem.value = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
}

