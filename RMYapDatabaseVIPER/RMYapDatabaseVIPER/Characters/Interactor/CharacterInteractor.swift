//
//  CharacterInteractor.swift
//  RMYapDatabaseVIPER
//
//  Created by Ибрагим Габибли on 04.02.2025.
//

import Foundation

final class CharacterInteractor: CharacterInteractorProtocol {
    var presenter: CharacterPresenterProtocol?
    var networkManager: NetworkManagerProtocol?
    var storageManager: StorageManagerProtocol!

    func getCharacters() {
        let savedCharacters = storageManager.loadCharacters()

        if !savedCharacters.isEmpty {
            presenter?.charactersFetched(savedCharacters)
        } else {
            networkManager?.getCharacters { [weak self] result in
                switch result {
                case .success(let characters):
                    DispatchQueue.main.async {
                        self?.presenter?.charactersFetched(characters)
                        characters.forEach { character in
                            self?.storageManager.saveCharacter(character, key: "\(character.id)")
                        }
                    }
                case .failure(let error):
                    print("Failed to fetch characters: \(error.localizedDescription)")
                }
            }
        }
    }

    func gettCharacters() {
        if let savedCharacters = storageManager?.loadCharacters() {
            presenter?.charactersFetched(savedCharacters)
            return
        }

        networkManager?.getCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                self?.storageManager?.saveCharacters(characters)
                self?.presenter?.charactersFetched(characters)
            case .failure(let error):
                self?.presenter?.charactersFetchFailed(with: error)
            }
        }
    }
}
