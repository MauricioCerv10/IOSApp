//
//  TasksUtility.swift
//  Agenda
//
//  Created by KMMX on 22/10/20.
//

import Foundation
class TasksUtility{
    private static let key = "tasks"
    
    //archive
    private static func archive(_ tasks: [[Task]]) -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false)
    }
    
    //fetch
    static func fetch() -> [[Task]]? {
        guard let unarchiveData = UserDefaults.standard.object(forKey:  key) as? Data else{ return nil}
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchiveData) as? [[Task]] ?? [[]]
    }
    
    //save
    static func save(_ tasks: [[Task]]) {
        //archive the data
        let archiveTasks = archive(tasks)
        // set the objects for key
        UserDefaults.standard.set(archiveTasks, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
