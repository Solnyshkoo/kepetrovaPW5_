//
//  ArticleRouter.swift
//  kepetrovaPW5
//
//  Created by Ksenia Petrova on 13.11.2021.
//

import Foundation

import UIKit

@objc protocol ArticleRoutingLogic
{
}

protocol ArticleDataPassing
{
    var dataStore: ArticleDataStore? { get }
}
// MARK: Routing
class ArticleRouter: NSObject, ArticleRoutingLogic, ArticleDataPassing
{
    weak var viewController: ArticleViewController?
    var dataStore: ArticleDataStore?
    
    
}
