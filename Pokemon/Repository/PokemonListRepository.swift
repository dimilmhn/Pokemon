//
//  PokemonListRepository.swift
//  Pokemon
//
//  Created by Dimil T Mohan on 2021/07/10.
//

import Foundation
import UIKit
import CoreData

class PokemonListRepository {
    private let sessionProvider = NetworkServiceProvider()
    private let userDefaults = UserDefaults.standard
    private let pokemonStorageKey = "pokemonList"
    private let maxAllowedData = 300

    var retrivalCompletion: (([PokemonItem]?)->())?
    var retrivalFailure: ((Error?)->())?

    private var urlString: String? {
        if let data = userDefaults.data(forKey: pokemonStorageKey) {
            do {
                let decoder = JSONDecoder()
                let pokemonList = try decoder.decode(PokemonList.self, from: data)
                return pokemonList.nextListURLString
            } catch {
                print("Unable to Decode PokemonList (\(error))")
                return nil
            }
        }
        return nil
    }
    
    private var storedItems: [PokemonItem]? {
        if let data = userDefaults.data(forKey: pokemonStorageKey) {
            do {
                let decoder = JSONDecoder()
                let pokemonList = try decoder.decode(PokemonList.self, from: data)
                return pokemonList.items
            } catch {
                print("Unable to Decode PokemonList (\(error))")
                return nil
            }
        }
        return nil
    }
    // MARK: - Session Request API
    
    func retrievePokemonList(completion: @escaping(_ list: [PokemonItem]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        guard storedItems?.count ?? 0 < maxAllowedData else {
            completion(storedItems)
            return
        }
        retrivalCompletion = completion
        sessionProvider.request(type: PokemonList.self, service: PokemonListService(urlString)) { [weak self] response in
            switch response {
            case let .success(pokemonList):
                print(pokemonList)
                self?.updateDB(pokemonList)
            case let .failure(error):
                print(error)
                failure(error)
            }
        }
    }
    
    func fetchPokemonList(_ searchText: String, completion: @escaping(_ list: [PokemonItem]?) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        if let data = userDefaults.data(forKey: pokemonStorageKey) {
            do {
                let decoder = JSONDecoder()
                let pokemonList = try decoder.decode(PokemonList.self, from: data)
                guard searchText != "" else {
                    completion(pokemonList.items)
                    return
                }
                let filteredList = pokemonList.items?.filter { pokemonItem in
                    return pokemonItem.name.lowercased().contains(searchText.lowercased())
                }
                completion(filteredList)
            } catch {
                failure(PokemonError.noData)
            }
        } else {
            failure(PokemonError.noData)
        }
    }
    
    private func saveToDB(_ pokemoneList: PokemonList) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(pokemoneList)
            userDefaults.removeObject(forKey: pokemonStorageKey)
            userDefaults.set(data, forKey: pokemonStorageKey)
        } catch {
            print("Unable to Encode PokemonList (\(error))")
        }
    }
    
    private func updateDB(_ pokemoneList: PokemonList) {
        if let data = userDefaults.data(forKey: pokemonStorageKey) {
            do {
                let decoder = JSONDecoder()
                var currentPokemonList = try decoder.decode(PokemonList.self, from: data)
                guard let pokemonItems =  pokemoneList.items else {
                    return
                }
                currentPokemonList.count = pokemoneList.count
                currentPokemonList.previousListURLString = pokemoneList.previousListURLString
                currentPokemonList.nextListURLString = pokemoneList.nextListURLString
                
                if let _ = currentPokemonList.items {
                    currentPokemonList.items! +=  pokemonItems
                } else {
                    currentPokemonList.items = pokemonItems
                }
                didCompleteUpdation(currentPokemonList)
            } catch {
                didCompleteUpdation(pokemoneList)
                print("Unable to Decode PokemonList (\(error))")
            }
        } else {
            didCompleteUpdation(pokemoneList)
            print("No existing data available")
        }
    }
    
    private func didCompleteUpdation(_ pokemonList: PokemonList) {
        retrivalCompletion?(pokemonList.items)
        saveToDB(pokemonList)
    }
}
