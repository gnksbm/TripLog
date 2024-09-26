//
//  RealmStorage.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

import RealmSwift

protocol RealmStorage {
    func create(_ object: Object) throws
    func read<T: Object, U: Equatable>(
        _ type: T.Type,
        uniqueKeyPath keyPath: KeyPath<T, U>,
        value: U
    ) throws -> T
    func read<T: Object>(_ type: T.Type) -> [T]
    func update<T: Object>(_ object: T, _ block: (T) -> Void) throws
    func delete(_ object: Object) throws
}

enum RealmError: Error {
    case canNotFindObject
}

final class DefaultRealmStorage: RealmStorage {
    private let realm = try! Realm()
    
    func create(_ object: Object) throws {
        try realm.write {
            realm.add(object)
        }
    }
    
    func read<T: Object, U: Equatable>(
        _ type: T.Type,
        uniqueKeyPath keyPath: KeyPath<T, U>,
        value: U
    ) throws -> T {
        if let object = realm.objects(T.self).filter(
            { object in
                object[keyPath: keyPath] == value
            }
        ).first {
            return object
        } else {
            throw RealmError.canNotFindObject
        }
    }
    
    func read<T: Object>(_ type: T.Type) -> [T] {
        Array(realm.objects(type))
    }
    
    func update<T: Object>(_ object: T, _ block: (T) -> Void) throws {
        try realm.write {
            block(object)
        }
    }
    
    func delete(_ object: Object) throws {
        try realm.write {
            realm.delete(object)
        }
    }
}
