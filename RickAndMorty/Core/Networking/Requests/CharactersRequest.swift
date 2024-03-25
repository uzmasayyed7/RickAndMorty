//
//  CharactersRequest.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/7/24.
//

final class CharactersRequest: NetworkRequestProtocol {
    typealias ResponseType = GeneralAPIResponse<RickAndMortyCharacter>

    let endpoint: Endpoint
    let method: HTTPMethod = .GET

    init(name: String, status: String, gender: String, page: Int) {
        endpoint = .getCharacters(name: name, status: status,
                                  gender: gender, page: page)
    }
}
