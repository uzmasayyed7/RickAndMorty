//
//  APIError.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/7/24.
//

import Foundation

struct APIError: Decodable, Error {
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "error"
    }
}
