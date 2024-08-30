//
//  TaskReusableView.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 28.08.2024.
//

import UIKit

protocol TaskReusableViewDelegate: AnyObject {
    func didUpdateTodoValues(title: String, description: String, completed: Bool)
}

enum ButtonStates {
    case active
    case inactive
}

final class TaskReusableView: UIView {
    
    // MARK: Properties
    
    weak var delegate: TaskReusableViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Name of task"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private let titleValue: EditableLabel = {
        let label = EditableLabel()
        label.placeholder = "Enter title"
        return label
    }()
    
    private let descriptionValue: EditableLabel = {
        let label = EditableLabel()
        label.placeholder = "Enter description"
        return label
    }()
    
    private let completedTitle: UILabel = {
        let label = UILabel()
        label.text = "Status"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private let completedValue: UITextField = {
        let label = UITextField()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "Not completed"
        return label
    }()
    
    private let completedSwitch: UISwitch = {
        let completedSwitch = UISwitch()
        return completedSwitch
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setValues(_ todo: Todo) {
        titleValue.text = todo.todo
        descriptionValue.text = todo.todoDescription
        completedValue.text = boolToString(todo.completed)
        completedSwitch.isOn = todo.completed
        checkTodoValues()
    }
    
    // MARK: Private func
    
    private func checkTodoValues() {
        if (titleValue.text?.isEmpty ==  true ||
            descriptionValue.text?.isEmpty == true ||
            titleValue.text == nil ||
            descriptionValue.text == nil)
        {
            setButtonState(.inactive)
        } else {
            setButtonState(.active)
        }
    }
    
    private func configureView() {
        self.backgroundColor = .white
        checkTodoValues()
        titleValue.delegate = self
        descriptionValue.delegate = self
        
        let buttonAction = UIAction { action in
            self.checkTodoValues()
            self.delegate?.didUpdateTodoValues(title: self.titleValue.text ?? "",
                                               description: self.descriptionValue.text ?? "",
                                               completed: self.stringToBool(self.completedValue.text ?? ""))
        }
        
        let switchAction = UIAction { action in
            self.toggleSwitch()
        }
        
        saveButton.addAction(buttonAction, for: .touchUpInside)
        completedSwitch.addAction(switchAction, for: .valueChanged)
        
    }
    
    private func toggleSwitch() {
        let bool = boolToString(completedSwitch.isOn)
        completedValue.text = bool
    }
    
    private func stringToBool(_ value: String) -> Bool {
        value == "Completed" ? true : false
    }
    
    private func boolToString(_ bool: Bool) -> String {
        bool == true ? "Completed" : "Not completed"
    }
    
    private func setButtonState(_ state: ButtonStates) {
        switch state {
        case .active:
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor.greenCompleted
        case .inactive:
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.greenInactive
        }
    }
    
    private func layoutViews() {
        
        self.addSubviews(titleLabel, descriptionLabel, completedTitle, saveButton)
        self.addSubviews(titleValue, descriptionValue, completedValue, completedSwitch)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleValue.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleValue.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)        }
        
        descriptionValue.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        completedTitle.snp.makeConstraints {
            $0.top.equalTo(descriptionValue.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        completedValue.snp.makeConstraints {
            $0.top.equalTo(completedTitle.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        completedSwitch.snp.makeConstraints {
            $0.top.equalTo(completedTitle.snp.bottom).offset(8)
            $0.centerY.equalTo(completedValue.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-32)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(52)
        }
    }
}

// MARK: EditableLabelDelegate

extension TaskReusableView: EditableLabelDelegate {
    
    func didChangeValue(_ text: String) {
        if (text.isEmpty == true) {
            setButtonState(.inactive)
        } else {
            setButtonState(.active)
        }
    }
}
