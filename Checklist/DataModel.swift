//
//  DataModel.swift
//  Checklist
//
//  Created by Jerry Li on 3/15/20.
//  Copyright © 2020 Jerry Li. All rights reserved.
//

import Foundation

class DataModel {
    
    var allChecklists = [Checklist]()
    
    let checklistIndexKey = "ChecklistIndex"
    
    init() {
        loadChecklists()
    }
    
    func documentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func checklistFilePath() -> URL {
        print(documentDirectory())
        return documentDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveCheckLists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(allChecklists)
            try data.write(to: checklistFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array:\(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        let path = checklistFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                allChecklists = try decoder.decode([Checklist].self, from: data)
            }catch {
                print("Error decoding list array:\(error.localizedDescription)")
            }
        }
    }
    
    //MARK:- User Default
    func store(checklistIndex: Int) {
        UserDefaults.standard.set(checklistIndex, forKey: checklistIndexKey)
    }
    
    func resetChecklistIndex() {
        UserDefaults.standard.set(-1, forKey: checklistIndexKey)
    }
    
    func getChecklistIndex() -> Int {
        return UserDefaults.standard.integer(forKey: checklistIndexKey)
    }
    
    
}
