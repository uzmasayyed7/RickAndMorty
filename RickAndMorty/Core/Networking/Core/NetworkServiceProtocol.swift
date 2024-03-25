//
//  NetworkServiceProtocol.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/7/24.
//

import Foundation
import Combine

protocol NetworkServiceProtocol: AnyObject {
    var customDecoder: JSONDecoder { get }
    
    func fetch<T: NetworkRequestProtocol>(_ request: T) async throws -> T.ResponseType
}
