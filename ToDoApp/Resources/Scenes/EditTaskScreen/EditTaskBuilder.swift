//
//  EditTaskBuilder.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 27.08.2024.
//

import Foundation

final class EditTaskBuilder {
    
    static func build(with todo: Todo, delegate: TaskListUpdateDelegate) -> EditTaskViewController {
        
        let interector = EditTaskInteractor()
        let presenter = EditTaskPresenter()
        let vc = EditTaskViewController()
        
        presenter.delegate = delegate
        vc.presenter = presenter
        presenter.view = vc
        interector.presenter = presenter
        interector.todo = todo
        presenter.interactor = interector
        
        return vc
    }
}
