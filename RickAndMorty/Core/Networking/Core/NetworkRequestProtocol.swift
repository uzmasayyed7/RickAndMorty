//
//  NetworkRequestProtocol.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/7/24.
//

protocol NetworkRequestProtocol {
    associatedtype ResponseType: Decodable
    
    var endpoint: Endpoint { get }
    var method: HTTPMethod { get }
}
