//
//  TaskListBuilder.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import UIKit

final class TaskListBuilder {
    static func build() -> UIViewController {
        let apiService = APIService()
        
        let interector = TaskListInteractor(apiService: apiService)
        let presenter = TaskListPresenter(interactor: interector)
        let vc = TaskListViewController()
        
        vc.presenter = presenter
        presenter.view = vc
        interector.presenter = presenter
        
        return vc
    }
}
