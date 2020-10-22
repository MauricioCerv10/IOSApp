//
//  TaskHelper.swift
//  Agenda
//
//  Created by KMMX on 21/10/20.
//

import Foundation
class TaskHelper{
    //atributes
    var tasks = [[Task](),[Task]()]
    //inits
    
    //methods
    func add(_ task:Task, at index: Int, isDone:Bool = false){
        let section = isDone ? 1 : 0
        tasks[section].insert(task, at: index)
    }
    func remove(at index: Int, isDone:Bool = false) -> Task{
        let section = isDone ? 1:0
        return tasks[section].remove(at: index)
    }
}
