//
//  ArticlePresentor.swift
//  kepetrovaPW5
//
//  Created by Ksenia Petrova on 13.11.2021.
//

import Foundation

protocol ArticlePresentationLogic {
    func presentData(response: ArticleModel.Fetch.Response)
}

class ArticlePresenter {
    
    weak var viewController: ArticleDisplayLogic?
}

// MARK: - Presentation logic
extension ArticlePresenter: ArticlePresentationLogic {
    func presentData(response: ArticleModel.Fetch.Response) {
        viewController?.displayData(articles: response.news!)
    }
}
