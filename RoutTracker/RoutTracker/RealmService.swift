//
//  RealmService.swift
//  RoutTracker
//
//  Created by Владислав Лазарев on 01.10.2021.
//

import Foundation
import RealmSwift

class RealmService {
    private lazy var realm: Realm? = {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try? Realm(configuration: realmConfig)
        return realm
    }()
    
    func writeToRealm<T: Object>(_ objects: [T]) {
        do {
            let realm = try Realm()
            let oldData = realm.objects(T.self)
            try realm.write {
                realm.delete(oldData)
                realm.add(objects)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getObjects<T: Object>(_ object: T.Type) -> [T] {
        do {
            let realm = try Realm()
            let objects = realm.objects(T.self)
            return Array(objects)
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}
