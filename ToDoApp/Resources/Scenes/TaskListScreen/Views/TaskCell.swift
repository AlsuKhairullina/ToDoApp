//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 25.08.2024.
//

import UIKit
import SnapKit

final class TaskCell: UITableViewCell {
    
    static let id = "TodoCell"
    
    private let todoTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let todoCompleted: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
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
        
        if task.completed == true {
            todoCompleted.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            todoCompleted.image = UIImage(systemName: "circle")
        }
    }
    
    private func setupViews() {
        
        contentView.addSubview(todoTitle)
        contentView.addSubview(todoCompleted)
        
        todoTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        todoCompleted.snp.makeConstraints {
            $0.centerY.equalTo(todoTitle.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(todoTitle.snp.trailing).offset(12)
            $0.size.equalTo(24)
        }
    }
}
