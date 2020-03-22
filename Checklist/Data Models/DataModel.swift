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
    
    static let checklistIndexKey = "ChecklistIndex"
    static let checklistFirstTimekey = "FirstTime"
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: DataModel.checklistIndexKey)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: DataModel.checklistIndexKey)
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
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
    private func registerDefaults() {
        let defaultChecklistIndexDictionary = [DataModel.checklistIndexKey: -1, DataModel.checklistFirstTimekey: true]
        as [String: Any]
        UserDefaults.standard.register(defaults: defaultChecklistIndexDictionary)
    }
    
    private func handleFirstTime() {
        let userDefault = UserDefaults.standard
        let isFirstTime = userDefault.bool(forKey: DataModel.checklistFirstTimekey)
        if isFirstTime {
            let checklist = Checklist(name: "List")
            allChecklists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefault.set(false, forKey: DataModel.checklistFirstTimekey)
        }
    }
    
    func sortChecklist() {
        allChecklists.sort(by: {one, anohter -> Bool in
            one.name.localizedStandardCompare(anohter.name) == .orderedAscending
        })
    }
}
