//
//  ArticleInteractor.swift
//  kepetrovaPW5
//
//  Created by Ksenia Petrova on 13.11.2021.
//

import Foundation

protocol ArticleBusinessLogic
{
    func loadFreshNews(request: ArticleModel.Fetch.Request)
}

protocol ArticleDataStore
{
    
}

class ArticleInteractor
{
    var presenter: ArticlePresentationLogic?
    var worker: ArticleWorker?
}

// MARK: - Business logic
extension ArticleInteractor: ArticleBusinessLogic, ArticleDataStore
{
    func loadFreshNews(request: ArticleModel.Fetch.Request)
    {
        worker = ArticleWorker()
        if request.pageIndex == nil || request.rubricIndex == nil {
            self.presenter?.presentData(response: ArticleModel.Fetch.Response(news: nil, requestId: nil))
        } else {
            worker?.fetch(rubricIndex: request.rubricIndex, pageIndex: request.pageIndex, completion: { result in
                
                switch result {
                case .success(let posts):
                    self.presenter?.presentData(response: posts)
                case .failure(let error):
                    print("Eror: \(error.localizedDescription)")
                }
            })
        }
    }

}
