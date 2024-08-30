//
//  EditTaskPresenter.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 27.08.2024.
//

import Foundation

protocol EditTaskPresenterProtocol: AnyObject {
    var view: EditTaskViewProtocol? { get set }
    var interactor: EditTaskInteractorProtocol? { get set }
    func viewDidLoad()
    func editTodo(newTitle: String, newDescription: String, newStatus: Bool)
    func updateAndClose()
}

final class EditTaskPresenter: EditTaskPresenterProtocol {
    
    weak var view: EditTaskViewProtocol?
    var interactor: EditTaskInteractorProtocol?
    
    weak var delegate: TaskListUpdateDelegate?
    
    func viewDidLoad() {
        guard let todo = interactor?.todo else { return }
        view?.showTaskDetails(todo)
    }
    
    func editTodo(newTitle: String, newDescription: String, newStatus: Bool) {
        interactor?.editTodo(newTitle: newTitle,
                             newDescription: newDescription,
                             newStatus: newStatus)
    }
    
    func updateAndClose() {
        delegate?.didUpdateList()
    }
    
}
