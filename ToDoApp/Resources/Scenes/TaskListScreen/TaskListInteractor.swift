//
//  TaskListInteractor.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func loadTodos()
    func deleteTodo(with id: String)
    func loadTasksFromAPI()
    func loadTasksFromCoreData()
}

final class TaskListInteractor: TaskListInteractorProtocol {
    
    weak var presenter: TaskListPresenterProtocol?
    let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func loadTodos() {
        isFirstLaunch() ? loadTasksFromAPI() : loadTasksFromCoreData()
    }
    
    func loadTasksFromAPI() {
        apiService.fetchTasks { [weak self] data in
            self?.presenter?.dataLoaded(data: data)
            CoreDataService.shared.saveToCoreData(tasks: data)
        }
    }
    
    func deleteTodo(with id: String) {
        CoreDataService.shared.deleteTodo(with: id)
    }
    
    func loadTasksFromCoreData() {
        CoreDataService.shared.fetchTodos { [weak self] data in
            self?.presenter?.dataLoaded(data: data)
        }
    }
    
    func isFirstLaunch() -> Bool {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "hasLaunchedBefore") {
            return false
        } else {
            userDefaults.set(true, forKey: "hasLaunchedBefore")
            return true
        }
    }
}
