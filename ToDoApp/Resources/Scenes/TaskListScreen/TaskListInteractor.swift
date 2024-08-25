//
//  TaskListInteractor.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    func loadTasksFromAPI() async -> TodoData?
    func loadTasksFromCoreData()
}

final class TaskListInteractor: TaskListInteractorProtocol {
    
    weak var presenter: TaskListPresenterProtocol?
    let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func loadTasksFromAPI() async -> TodoData? {
        do {
            let data = try await apiService.fetchTasks()
            return data
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadTasksFromCoreData() {
        print("core data")
    }
}
