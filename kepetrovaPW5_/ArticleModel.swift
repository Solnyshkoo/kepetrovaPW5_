//
//  ArticleModel.swift
//  kepetrovaPW5
//
//  Created by Ksenia Petrova on 13.11.2021.
//

import Foundation

import UIKit

struct ArticleModel: Decodable{
    struct Fetch: Decodable {
        struct Request: Decodable
        {
            var rubricIndex: Int?
            var pageIndex: Int?
            
        }
        struct Response: Decodable
        {
            var news: [ArticleView]?
            var requestId: String?
            mutating func passTheRequestId() {
                for i in 0..<(news?.count ?? 0) {
                    news?[i].requestId = requestId
                }
            }
        }
        struct ImageContainer: Decodable
        {
            var url: URL?
        }
        struct ArticleView: Decodable
        {
            var articleId: Int?
            var title: String
            var description: String
            var date: String?
            var img: ImageContainer?
            var requestId: String?
            var articleUrl: URL? {
                let requestId = requestId ?? ""
                let articleId = articleId ?? 0
                return URL(string: "https://news.myseldon.com/ru/news/index/\(articleId)?requestId=\(requestId)")
            }
            
            enum CodingKeys: String, CodingKey {
                case articleId = "newsId"
                case title = "title"
                case description = "announce"
                case date = "date"
                case requestId, img
            }
        }
    }
}


