//
//  NewTaskPresenter.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 28.08.2024.
//

import Foundation

protocol NewTaskPresenterProtocol: AnyObject {
    var view: NewTaskViewProtocol? { get set }
    var interactor: NewTaskInteractorProtocol? { get set }
    func addTodo(title: String, description: String, completed: Bool)
    func updateAndClose()
}

final class NewTaskPresenter: NewTaskPresenterProtocol {
    
    weak var view: NewTaskViewProtocol?
    var interactor: NewTaskInteractorProtocol?
    
    weak var delegate: TaskListUpdateDelegate?
    
    func addTodo(title: String, description: String, completed: Bool) {
        interactor?.addTodo(title: title, description: description, completed: completed)
    }
    
    func updateAndClose() {
        delegate?.didUpdateList()
    }
}
