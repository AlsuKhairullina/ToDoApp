//
//  EditTaskViewController.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 27.08.2024.
//

import UIKit

protocol EditTaskViewProtocol: AnyObject {
    var presenter: EditTaskPresenterProtocol? { get set }
    func showTaskDetails(_ todo: Todo)
}

final class EditTaskViewController: UIViewController {
    
    var presenter: EditTaskPresenterProtocol?
    
    let taskView = TaskReusableView()
    
    override func loadView() {
        self.view = taskView
    }
    
    override func viewDidLoad() {
        presenter?.viewDidLoad()
        taskView.delegate = self
    }
    
}

extension EditTaskViewController: EditTaskViewProtocol {

    func showTaskDetails(_ todo: Todo) {
        taskView.setValues(todo)
    }
}

// MARK: TaskReusableViewDelegate

extension EditTaskViewController: TaskReusableViewDelegate {
    
    func didUpdateTodoValues(title: String, description: String, completed: Bool) {
        presenter?.editTodo(newTitle: title, newDescription: description, newStatus: completed)
        self.presenter?.updateAndClose()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true)
        }
    }
}
