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
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ArticleDataPassing
{
    var dataStore: ArticleDataStore? { get }
}

class ArticleRouter: NSObject, ArticleRoutingLogic, ArticleDataPassing
{
    weak var viewController: ArticleViewController?
    var dataStore: ArticleDataStore?
    
    // MARK: Routing
}
