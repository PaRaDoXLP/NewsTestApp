//
//  NTADatabaseManager.swift
//  NewsTestApp
//
//  Created by Вячеслав on 10/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import UIKit
import RealmSwift

class NTADatabaseManager: NSObject {
        
    private var realm:Realm
    static let sharedInstance = NTADatabaseManager()

    override init() {
        //Realm BASIC migration setup
        let config = Realm.Configuration(
          // Set the new schema version. This must be greater than the previously used
          // version (if you've never set a schema version before, the version is 0).
          schemaVersion: 0,

          // Set the block which will be called automatically when opening a Realm with
          // a schema version lower than the one set above
          migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
              // Nothing to do!
              // Realm will automatically detect new properties and removed properties
              // And will update the schema on disk automatically
            }
        })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        self.realm = try! Realm()
    }
    
    func allNews() -> [NTANewsEntity] {
        return Array(realm.objects(NTANewsEntity.self))
    }
    
    func saveNewsEntity(newsEntities: [NTANewsEntity]) {
        do {
            self.realm.beginWrite()
            self.realm.add(newsEntities, update: Realm.UpdatePolicy.all)
            try self.realm.commitWrite()
        } catch {
            print("\(error.localizedDescription)")
        }
        
        
        
    }
}
