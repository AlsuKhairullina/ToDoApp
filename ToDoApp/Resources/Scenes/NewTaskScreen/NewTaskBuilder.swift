//
//  NewTaskBuilder.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 28.08.2024.
//

import Foundation

final class NewTaskBuilder {
    
    static func build(delegate: TaskListUpdateDelegate) -> NewTaskViewController {
        
        let presenter = NewTaskPresenter()
        let interactor = NewTaskInteractor()
        let vc = NewTaskViewController()
        
        vc.presenter = presenter
        presenter.view = vc
        presenter.delegate = delegate
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        return vc
    }
}
