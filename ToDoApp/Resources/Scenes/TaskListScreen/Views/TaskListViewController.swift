//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import UIKit

enum FilterCases: String, CaseIterable {
    case all = "All"
    case complete = "Complete"
    case notComplete = "Not Complete"
}

enum TaskListState {
    case loading
    case done
    case error
}

protocol TaskListViewProtocol: AnyObject {
    func setState(_ state: TaskListState)
    func updateTable(_ data: [Todo])
    func updateAfterChange()
}

final class TaskListViewController: UIViewController {
    
    // MARK: Properties
    
    var presenter: TaskListPresenterProtocol?
    
    var todos: [Todo] = []
    
    var filteredTodos = [Todo]()
    
    private var currentFilter: FilterCases = .all
    
    private var screenState: TaskListState = .loading
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .medium
        spinner.color = .black
        return spinner
        
    }()
    
    private let filterView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.id)
        return tableView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
        presenter?.fetchData()
        configureFilterView()
        configureView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: Private func
    
    private func configureView() {
        
        view.backgroundColor = .white
        title = "Tasks"
        
        let action = UIAction { action in
            self.presenter?.showNewTaskScreen()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            primaryAction: action)
    }
    
    private func layoutViews() {
        
        view.addSubviews(tableView, filterView, spinner)
        
        filterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(filterView.snp.bottom).offset(12)
            $0.bottom.trailing.leading.equalToSuperview()
        }
        
        spinner.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func filterTasks() {
        
        switch currentFilter {
        case .all:
            filteredTodos = todos.reversed()
        case .complete:
            filteredTodos = todos.filter { $0.completed }
        case .notComplete:
            filteredTodos = todos.filter { !$0.completed }.reversed()
        }
        tableView.reloadData()
    }
    
    private func configureFilterView() {
        
        for filter in FilterCases.allCases {
            let button = UIButton(type: .system)
            button.setTitle(filter.rawValue, for: .normal)
            button.backgroundColor = .clear
            button.layer.borderWidth = 0.7
            button.layer.cornerRadius = 12
            let action = UIAction { action in
                self.actionForButton(filter: filter)
            }
            button.addAction(action, for: .touchUpInside)
            filterView.addArrangedSubview(button)
            
        }
    }
    
    private func actionForButton(filter: FilterCases) {
        switch filter {
        case .all:
            currentFilter = .all
            filterTasks()
        case .complete:
            currentFilter = .complete
            filterTasks()
        case .notComplete:
            currentFilter = .notComplete
            filterTasks()
        }
    }
}

extension TaskListViewController: TaskListViewProtocol {
    
    func setState(_ state: TaskListState) {
        
        switch state {
        case .loading:
            tableView.isHidden = true
            filterView.isHidden = true
            DispatchQueue.main.async {
                self.spinner.startAnimating()
            }
        case .done:
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.spinner.removeFromSuperview()
                self.tableView.isHidden = false
                self.filterView.isHidden = false
            }
        case .error:
            view.backgroundColor = .red
        }
    }
    
    func updateTable(_ data: [Todo]) {
        self.todos = data
        DispatchQueue.main.async {
            self.filterTasks()
            self.tableView.reloadData()
        }
    }
    
    func updateAfterChange() {
        presenter?.fetchData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTodos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.id, for: indexPath) as! TaskCell
        cell.configureCell(task: filteredTodos[indexPath.row])
        cell.delegate = self
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
}

// MARK: TaskCellDelegate

extension TaskListViewController: TaskCellDelegate {
    
    func didTapOption(option: ButtonOptions, todo: Todo) {
        switch option {
        case .edit:
            presenter?.showEditTaskScreen(todo: todo)
        case .delete:
            presenter?.deleteTodo(with: todo.id)
            updateAfterChange()
        }
    }
    
}
