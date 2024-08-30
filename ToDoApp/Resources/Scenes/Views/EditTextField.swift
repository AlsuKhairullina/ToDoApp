//
//  EditTextField.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 28.08.2024.
//

import UIKit

protocol EditableLabelDelegate: AnyObject {
    func didChangeValue(_ text: String)
}

final class EditableLabel: UIView {
    
    weak var delegate: EditableLabelDelegate?

    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isHidden = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 18)
        label.isHidden = true
        return label
    }()
    
    var text: String? {
        didSet {
            label.text = text
            textView.text = text
            updatePlaceholderVisibility()
            adjustTextViewHeight()
        }
    }

    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            updatePlaceholderVisibility()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(label)
        addSubview(textView)
        addSubview(placeholderLabel)
        
        label.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.top)
            $0.leading.equalTo(textView.snp.leading)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
        label.addGestureRecognizer(tapGesture)
        textView.delegate = self
    }
    
    @objc private func handleLabelTap() {
        label.isHidden = true
        textView.isHidden = false
        placeholderLabel.isHidden = !textView.text.isEmpty
        textView.becomeFirstResponder()
    }
    
    private func endEditingAndSaveText() {
        label.isHidden = false
        textView.isHidden = true
        text = textView.text
    }
    
    private func adjustTextViewHeight() {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !(textView.text.isEmpty)
        
        if label.text?.isEmpty == true {
            placeholderLabel.isHidden = false
        }
    }
}

extension EditableLabel: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        endEditingAndSaveText()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            endEditingAndSaveText()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewHeight()
        updatePlaceholderVisibility()
        delegate?.didChangeValue(textView.text)
    }
}






