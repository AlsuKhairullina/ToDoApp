//
//  TaskListPresenter.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    
    var view: TaskListViewProtocol? { get set }
    var interactor: TaskListInteractorProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }
    func fetchData()
    func dataLoaded(data: [Todo])
    func deleteTodo(with id: String)
    func showEditTaskScreen(todo: Todo)
    func showNewTaskScreen()
}

protocol TaskListUpdateDelegate: AnyObject {
    func didUpdateList()
}

final class TaskListPresenter: TaskListPresenterProtocol {

    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    func fetchData() {
        view?.setState(.loading)
        interactor?.loadTodos()
    }
    
    func dataLoaded(data: [Todo]) {
        view?.updateTable(data)
        view?.setState(.done)
    }
    
    func deleteTodo(with id: String) {
        interactor?.deleteTodo(with: id)
    }
    
    func showEditTaskScreen(todo: Todo) {
        guard let view = view else { return }
        router?.openEditTaskScreen(from: view, for: todo, delegate: self)
    }
    
    func showNewTaskScreen() {
        guard let view = view else { return }
        router?.openNewTaskScreen(from: view, delegate: self)
    }
    
}

extension TaskListPresenter: TaskListUpdateDelegate {
    
    func didUpdateList() {
        view?.updateAfterChange()
    }
}
