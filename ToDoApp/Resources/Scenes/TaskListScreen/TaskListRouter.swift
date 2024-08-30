//
//  TaskListRouter.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 27.08.2024.
//

import UIKit

protocol TaskListRouterProtocol: AnyObject {
    func openEditTaskScreen(from view: TaskListViewProtocol, for todo: Todo, delegate: TaskListUpdateDelegate)
    func openNewTaskScreen(from view: TaskListViewProtocol, delegate: TaskListUpdateDelegate)
}

final class TaskListRouter: TaskListRouterProtocol {
    
    func openEditTaskScreen(from view: TaskListViewProtocol,
                            for todo: Todo,
                            delegate: TaskListUpdateDelegate) {
        let editScreen = EditTaskBuilder.build(with: todo, delegate: delegate)
        
        guard let viewVC = view as? UIViewController else { return }
        viewVC.navigationController?.present(editScreen, animated: true)
    }
    
    func openNewTaskScreen(from view: TaskListViewProtocol, delegate: TaskListUpdateDelegate) {
        let newTaskScreen = NewTaskBuilder.build(delegate: delegate)
        
        guard let viewVC = view as? UIViewController else { return }
        viewVC.navigationController?.present(newTaskScreen, animated: true)
    }
}
