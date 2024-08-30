//
//  NewTaskViewController.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 28.08.2024.
//

import UIKit

protocol NewTaskViewProtocol: AnyObject { }

final class NewTaskViewController: UIViewController {
    
    var presenter: NewTaskPresenterProtocol?
    
    let taskView = TaskReusableView()
    
    override func loadView() {
        self.view = taskView
    }
    
    override func viewDidLoad() {
        taskView.delegate = self
    }

}
extension NewTaskViewController: NewTaskViewProtocol {}

extension NewTaskViewController: TaskReusableViewDelegate {
    
    func didUpdateTodoValues(title: String, description: String, completed: Bool) {
        presenter?.addTodo(title: title, description: description, completed: completed)
        self.presenter?.updateAndClose()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true)
        }
    }
}
