//
//  UITableView+Loading.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/8/24.
//

import Foundation
import UIKit

extension UITableView {
    func setLoading() { 
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .white
        self.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
        self.separatorStyle = .none
    }
}
