//
//  YapDatabaseError.swift
//  RMYapDatabaseVIPER
//
//  Created by Ибрагим Габибли on 02.02.2025.
//

import Foundation

enum YapDatabaseError: Error {
    case databaseInitializationFailed
    case encodingFailed(Error)
    case decodingFailed(Error)
}
