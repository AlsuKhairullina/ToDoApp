//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import UIKit

protocol TaskListViewProtocol: AnyObject {
    func showList()
}

final class TaskListViewController: UIViewController {
    
    var presenter: TaskListPresenterProtocol?
    
    var todos = TodoData(todos: [])
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await loadData()
        }
        showList()
        configureView()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //    func viewLoaded() {
    //        Task {
    //            guard let data = await presenter?.viewLoaded() else { return }
    //            self.todos = data
    //        }
    //    }
    
    func loadData() async {
        guard let data = await presenter?.viewLoaded() else { return }
        self.todos = data
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func configureView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
    }
}

extension TaskListViewController: TaskListViewProtocol {
    
    func showList() {
        print("show list")
    }
    
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.todos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.id, for: indexPath) as! TaskCell
        cell.configureCell(task: todos.todos[indexPath.row])
        return cell
    }
}
