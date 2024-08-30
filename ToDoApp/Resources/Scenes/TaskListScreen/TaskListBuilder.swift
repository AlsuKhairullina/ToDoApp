//
//  TaskListBuilder.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import UIKit

final class TaskListBuilder {
    
    static func build() -> TaskListViewController {
        let apiService = APIService()
        
        let router = TaskListRouter()
        let interactor = TaskListInteractor(apiService: apiService)
        let presenter = TaskListPresenter()
        let vc = TaskListViewController()
        
        vc.presenter = presenter
        presenter.view = vc
        presenter.router = router
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        return vc
    }
}
