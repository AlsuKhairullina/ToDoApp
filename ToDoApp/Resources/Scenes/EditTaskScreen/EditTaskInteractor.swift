//
//  EditTaskInteractor.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 27.08.2024.
//

import Foundation

protocol EditTaskInteractorProtocol: AnyObject {
    var presenter: EditTaskPresenterProtocol? { get set }
    var todo: Todo? { get set }
    func editTodo(newTitle: String, newDescription: String, newStatus: Bool)
}

final class EditTaskInteractor: EditTaskInteractorProtocol {
    
    weak var presenter: EditTaskPresenterProtocol?

    var todo: Todo?
    
    func editTodo(newTitle: String, newDescription: String, newStatus: Bool) {
        guard let id = todo?.id else { return }
        CoreDataService.shared.updateTodo(with: id,
                                   newTitle: newTitle,
                                   newDescription: newDescription,
                                   newStatus: newStatus)
    }
}
