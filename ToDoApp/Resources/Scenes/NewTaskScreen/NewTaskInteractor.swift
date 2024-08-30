//
//  NewTaskInteractor.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 28.08.2024.
//

import Foundation

protocol NewTaskInteractorProtocol: AnyObject {
    var presenter: NewTaskPresenterProtocol? { get set }
    func addTodo(title: String, description: String, completed: Bool)
}

final class NewTaskInteractor: NewTaskInteractorProtocol {
    
    weak var presenter: NewTaskPresenterProtocol?
    
    var todo: Todo?
    
    func addTodo(title: String, description: String, completed: Bool) {
        CoreDataService.shared.addNewTodo(title: title,
                                   description: description,
                                   completed: completed)
    }
}
