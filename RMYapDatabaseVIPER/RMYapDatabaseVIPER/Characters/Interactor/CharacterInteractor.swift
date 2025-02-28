//
//  CharacterInteractor.swift
//  RMYapDatabaseVIPER
//
//  Created by Ибрагим Габибли on 04.02.2025.
//

import Foundation
import UIKit.UIImage

final class CharacterInteractor: CharacterInteractorProtocol {
    private let presenter: CharacterPresenterProtocol
    private let networkManager: NetworkManagerProtocol
    private let storageManager: StorageManagerProtocol

    init(presenter: CharacterPresenterProtocol,
         networkManager: NetworkManagerProtocol,
         storageManager: StorageManagerProtocol
    ) {
        self.presenter = presenter
        self.networkManager = networkManager
        self.storageManager = storageManager
    }

    func getCharacters() {
        let savedCharacters = storageManager.loadCharacters()

        if !savedCharacters.isEmpty {
            presenter.charactersFetched(savedCharacters)
        } else {
            networkManager.getCharacters { [weak self] result in
                switch result {
                case .success(let characters):
                    DispatchQueue.main.async {
                        self?.presenter.charactersFetched(characters)
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

    func loadImage(for character: Character, completion: @escaping (UIImage?) -> Void) {
        networkManager.loadImage(from: character.image, completion: completion)
    }
}
