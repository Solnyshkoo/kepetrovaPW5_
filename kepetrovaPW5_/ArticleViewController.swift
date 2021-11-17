//
//  ViewController.swift
//  kepetrovaPW5
//
//  Created by Ksenia Petrova on 13.11.2021.
//

import UIKit

protocol ArticleDisplayLogic: AnyObject {
    func displayData(articles: [ArticleModel.Fetch.ArticleView])
}

class ArticleViewController: UIViewController {

    private var interactor: ArticleBusinessLogic?
    
    private var router: (NSObjectProtocol & ArticleRoutingLogic & ArticleDataPassing)?
    
    private var data: [ArticleModel.Fetch.ArticleView] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        interactor?.loadFreshNews(request: ArticleModel.Fetch.Request(rubricIndex: 4, pageIndex: 1))
        setupTableView()
       
    }
    let tableView = UITableView()
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "cellId")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        tableView.pin(to: view, .left, .right)
        tableView.backgroundColor = .systemBlue
        tableView.dataSource = self
        tableView.delegate = self
       // tableView.rowHeight = UITableView.automaticDimension
       // tableView.rowHeight = UITableView.automaticDimension
        //tableView.contentSize
        //tableView.estimatedRowHeight = 80
    }

}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? ArticleCell
        cell?.addView()
        
       // print(data[indexPath.row].title)
       
        
        cell?.text.text = data[indexPath.row].title
        cell?.descr.text = data[indexPath.row].description
        cell?.img.image = loadImage(url: (data[indexPath.row].img?.url)!)
        cell?.layer.cornerRadius = 30
        return cell ?? UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 300
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1;
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadImage(url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }
}

extension ArticleViewController: ArticleDisplayLogic {
    func displayData(articles: [ArticleModel.Fetch.ArticleView]) {
        self.data = articles
        DispatchQueue.main.async {
           self.tableView.reloadData()
        }
        
    }
}
