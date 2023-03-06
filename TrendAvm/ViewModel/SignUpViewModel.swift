//
//  SignUpViewModel.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 2.03.2023.
//

import Foundation

import Alamofire

class SignUpViewModel {
    
    var signUpResponse = Observable<SignUpResponse>()
    var isLoading = Observable<Bool>()
    var alertItem = Observable<AlertItem>()
    
    func addNewUser(email:String, username:String, password:String, name:Name, address:Adres, phone:String){
        isLoading.value = true
        
        NetworkManager.instance.fetch(endpoint: TrendAvmEndPoint.addNewUser(request: SignUpRequest(email: email, username: username, password: password, name: name, address: address, phone: phone)), responseModel:SignUpResponse .self){ [self] result in
            
            DispatchQueue.main.async { [self] in
                isLoading.value = false
                
                switch result {
                case .success(let result):
                    self.signUpResponse.value = result
                    
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
