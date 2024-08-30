//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import UIKit
import SnapKit

protocol TaskCellDelegate: AnyObject {
    func didTapOption(option: ButtonOptions, todo: Todo)
}

enum ButtonOptions {
    case edit
    case delete
}

final class TaskCell: UITableViewCell {
    
    // MARK: Properties
    
    static let id = "TodoCell"
    
    weak var delegate: TaskCellDelegate?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let todoTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor.blackText
        label.numberOfLines = 0
        return label
    }()
    
    private let todoDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.blackText
        label.numberOfLines = 0
        return label
    }()
    
    private let todoDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor.blackText
        return label
    }()
    
    private let todoEditButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    private let todoCompleted: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    
    func configureCell(task: Todo) {
        
        todoTitle.text = task.todo
        todoDescription.text = task.todoDescription
        todoDate.text = task.date
        
        if task.completed == true {
            todoCompleted.text = "Completed"
            todoCompleted.textColor = UIColor.greenCompleted
        } else {
            todoCompleted.text = "Not completed"
            todoCompleted.textColor = UIColor.redNotCompleted
        }
        
        let editItem = UIAction(title: "Edit") { action in
            self.delegate?.didTapOption(option: .edit, todo: task)
        }
        
        let deleteItem = UIAction(title: "Delete") { action in
            self.delegate?.didTapOption(option: .delete, todo: task)
        }
        
        let menu = UIMenu(options: .displayInline, children: [editItem, deleteItem])
        
        todoEditButton.menu = menu
        todoEditButton.showsMenuAsPrimaryAction = true
    }
    
    
    private func setupViews() {
        
        contentView.addSubviews(stackView, todoEditButton, todoCompleted)
        
        stackView.addArrangedSubview(todoTitle)
        stackView.addArrangedSubview(todoDescription)
        stackView.addArrangedSubview(todoDate)
        
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        todoEditButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(stackView.snp.trailing).offset(12)
            $0.size.equalTo(20)
        }
        
        todoCompleted.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
}
