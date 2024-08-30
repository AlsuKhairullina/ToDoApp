//
//  FilterView.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 26.08.2024.
//

import UIKit

final class FilterView: UIView {
    
    private let filterTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    func configureView(title: String, count: Int) {
        
        self.addSubview(filterTitle)
        filterTitle.text = title
    }
}
