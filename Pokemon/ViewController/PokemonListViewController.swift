//
//  PokemonListViewController.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import UIKit

class PokemonListViewController: UIViewController {

    private var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        return activityIndicator
    }()
    
    private lazy var viewModel: PokemonListViewModel = {
        return PokemonListViewModel()
    }()
    
    private let cellIdentifier = "pokemonListTableViewCellIdentifier"
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterface()
        initialiseViewModel()
        configurePullToRefresh()
        configureSearchController()
    }
    
    // MARK: - View Coinfig

    private func configureUserInterface() {
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.navigationItem.title = "Pokemon"
        self.navigationController?.navigationBar.backgroundColor = UIColor.blue
        self.configureTableView()
        self.activityIndicator.center = self.tableView.center
        self.view.addSubview(activityIndicator)
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PokemonListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func configurePullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableView.addSubview(refreshControl)
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = UIColor.lightGray
        searchController.searchBar.barTintColor = UIColor.white
    }

    // MARK: - Functionalities
    
    private func initialiseViewModel() {
        viewModel.showAlert = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.didReloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        DispatchQueue.global().async {
            self.viewModel.initFetch()
        }
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.global().async {
            self.viewModel.initFetch()
        }
    }
}

extension PokemonListViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PokemonListTableViewCell else {
            fatalError("Cell not available")
        }
        
        let cellViewModel = viewModel.item(at: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        DispatchQueue.global().async {
            self.viewModel.searchContent(searchController.searchBar.text ?? "")
        }
    }
}
