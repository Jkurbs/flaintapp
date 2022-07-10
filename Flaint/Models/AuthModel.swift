//
//  AuthModel.swift
//  Flaint
//
//  Created by Kerby Jean on 7/10/22.
//  Copyright © 2022 Kerby Jean. All rights reserved.
//

import Combine
import Foundation

class AuthModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    var validateUsername: AnyPublisher<Bool?, Never> {
        return $username
            .map { username in
                username.lowercased()
            }
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { username in
                return Future { promise in
                    DataService.shared.usernameAvailable(username) { available in
                        promise(.success(available))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
}
