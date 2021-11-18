//
//  ArticleModel.swift
//  kepetrovaPW5
//
//  Created by Ksenia Petrova on 13.11.2021.
//
import Foundation

enum ObtainPostsResult {
    case success(posts: ArticleModel.Fetch.Response)
    case failure(error: Error)
}

class ArticleWorker {
    
    func fetch(rubricIndex: Int?, pageIndex: Int?, completion: @escaping (ObtainPostsResult) -> Void)
    {
        let url = URL(string: "https://news.myseldon.com/api/Section?rubricId=\(rubricIndex ?? 4)&pageSize=8&pageIndex=\(pageIndex ?? 1)")!

        URLSession.shared.dataTask(with: url) { data, repo, error in
            var result: ObtainPostsResult
            
            defer {
                completion(result)
            }
            
            if error == nil, let parseData = data {
                guard let post = try? JSONDecoder().decode(ArticleModel.Fetch.Response.self, from: parseData) else {
                    result = .failure(error: errSecInternalError as! Error)
                    return
                    
                }
                result = .success(posts: post)
            } else {
                result = .failure(error: error!)
              
            }
            completion(result)
        }.resume()
    }
   
}
