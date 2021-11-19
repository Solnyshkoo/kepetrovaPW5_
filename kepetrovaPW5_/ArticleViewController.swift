//
//  ViewController.swift
//  kepetrovaPW5
//
//  Created by Ksenia Petrova on 13.11.2021.
//

import UIKit
import WebKit

protocol ArticleDisplayLogic: AnyObject {
    func displayData(articles: [ArticleModel.Fetch.ArticleView])
}

extension ArticleViewController: ArticleDisplayLogic {
    func displayData(articles: [ArticleModel.Fetch.ArticleView]) {
        self.data.append(contentsOf: articles)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }
        
    }
}

class ArticleViewController: UIViewController, WKUIDelegate {
    
    // MARK: - Properties
    private var interactor: ArticleBusinessLogic?
    private var router: (NSObjectProtocol & ArticleRoutingLogic & ArticleDataPassing)?
    private var data: [ArticleModel.Fetch.ArticleView] = []
    private var refreshControl = UIRefreshControl()
    private var pageIndex: Int?
    
    let tableView = UITableView()
    var webView = WKWebView()
    var spiner = UIActivityIndicatorView(style: .large)
    
    // MARK: - init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - setup protocols
    private func setup() {
        
        let viewController = self
        let presenter = ArticlePresenter()
        let interactor = ArticleInteractor()
        let router = ArticleRouter()
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        spiner.color = .systemOrange
        view.addSubview(spiner)
        spiner.center = view.center
        spiner.startAnimating()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        pageIndex = 1
        interactor?.loadFreshNews(request: ArticleModel.Fetch.Request(rubricIndex: 4, pageIndex: pageIndex))
        setupTableView()
    }
    // MARK: - WKWebView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        spiner.startAnimating()
        spiner.removeFromSuperview()
    }
    
    
    
    // MARK: - setup TableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "cellId")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        tableView.pin(to: view, .left, .right)
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(loadMorePages), for: .valueChanged)
        refreshControl.tintColor = .systemOrange
    }
    
    @objc private func loadMorePages() {
        pageIndex! += 1;
        interactor?.loadFreshNews(request: ArticleModel.Fetch.Request(rubricIndex: 4, pageIndex: pageIndex))
    }
    
    func loadImage(url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else {return nil}
        return UIImage(data: data)
    }
    
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - create cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? ArticleCell
        cell?.addView()
        cell?.text.text = data[indexPath.row].title
        cell?.descr.text = data[indexPath.row].description
        cell?.img.image = loadImage(url: (data[indexPath.row].img?.url)!)
        // чуть-чуть костыльно ... времени мало((
        var count = data.count - 4;
        if indexPath.row == count {
            loadMorePages()
        }
        return cell ?? UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    // MARK: - working WKWebView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeWeb(sender:)))
        view.addSubview(webView)
        webView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        webView.pinRight(to: view)
        webView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        let url = data[indexPath.row].articleUrl
        webView.load(URLRequest(url: url!))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func closeWeb(sender: UIBarButtonItem){
        webView.removeFromSuperview()
    }
    
    // MARK: - setup swipe share
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let article = self.data[(indexPath as NSIndexPath).row] as ArticleModel.Fetch.ArticleView
        let shareAction = UIContextualAction(style: .normal, title: "Share") {
            (action, sourceView, completionHandler) in
            self.swipeShareAction(article, indexPath: indexPath)
            completionHandler(true)
        }
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [shareAction])
        return swipeConfiguration
    }
    
    fileprivate func swipeShareAction(_ article: ArticleModel.Fetch.ArticleView, indexPath: IndexPath) {
        
        let uploadItems = [article.articleUrl as AnyObject]
        let activityController = UIActivityViewController(activityItems: uploadItems, applicationActivities: nil)
        if let popoverController = activityController.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
        self.present(activityController, animated: true, completion: nil)
    }
}


