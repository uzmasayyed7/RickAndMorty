//
//  UICollectionView+Loading.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/8/24.
//

import Foundation
import UIKit

extension UICollectionView {
    func setLoading(){
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .white
        self.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
    }
}
