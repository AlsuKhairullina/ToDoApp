//
//  TaskListPresenter.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    var view: TaskListViewProtocol? { get set }
    
    func viewLoaded() async -> TodoData?
    func didLoadTasks(_: TodoData) async
}

final class TaskListPresenter: TaskListPresenterProtocol {
    
    weak var view: TaskListViewProtocol?
    let interactor: TaskListInteractorProtocol
    
    init(interactor: TaskListInteractorProtocol) {
        self.interactor = interactor
    }
    
    func viewLoaded() async -> TodoData?  {
        guard let data = await interactor.loadTasksFromAPI() else { return nil }
        return data
    }
    
    func didLoadTasks(_ : TodoData) async {
        view?.showList()
    }
    
}
