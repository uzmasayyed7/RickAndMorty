//
//  EpisodesRequest.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/7/24.
//

final class EpisodesRequest: NetworkRequestProtocol {
    typealias ResponseType = GeneralAPIResponse<Episode>

    let endpoint: Endpoint
    let method: HTTPMethod = .GET

    init(name: String, page: Int) {
        endpoint = .getEpisodes(for: name, page: page)
    }
}
