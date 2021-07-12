//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import Foundation

class PokemonListViewModel {
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlert?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    private var cellViewModels: [PokemonListCellViewModel] = [PokemonListCellViewModel]() {
        didSet {
            self.didReloadTableView?()
        }
    }
    
    private var repository = PokemonListRepository()

    var didReloadTableView: (()->())?
    var showAlert: (()->())?
    var updateLoadingStatus: (()->())?
    
    func initFetch() {
        self.isLoading = true
        repository.retrievePokemonList(completion: { [weak self] items in
            self?.isLoading = false
            guard let pokemonItems = items else {
                self?.processError(error: PokemonError.noData)
                return
            }
            self?.processToCellViewModels(items: pokemonItems)
        }, failure: { [weak self] error in
            self?.isLoading = false
            self?.processError(error: error)
        })
    }
    
    func searchContent(_ searchText: String) {
        repository.fetchPokemonList(searchText, completion: { [weak self] items in
            guard let pokemonItems = items else {
                self?.processError(error: PokemonError.unknown)
                return
            }
            self?.processToCellViewModels(items: pokemonItems)
        }, failure: { [weak self] error in
            self?.processError(error: error)
        })
    }
    
    private func processToCellViewModels(items: [PokemonItem]) {
        self.cellViewModels = items.map { PokemonListCellViewModel(name: $0.name, url: $0.url) }
    }
    
    func createCellViewModel(item: PokemonItem) -> PokemonListCellViewModel {
        return PokemonListCellViewModel(name: item.name, url: item.url)
    }
    
    func item(at indexPath: IndexPath ) -> PokemonListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    private func processError(error: Error?) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .unknown:
                self.alertMessage = NetworkError.unknown.rawValue
                
            case .noJSONData:
                self.alertMessage = NetworkError.noJSONData.rawValue
            }
        } else {
            self.alertMessage = NetworkError.unknown.rawValue
        }
    }
}
