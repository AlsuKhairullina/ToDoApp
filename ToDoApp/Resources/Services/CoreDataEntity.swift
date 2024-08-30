//
//  CoreDataEntity.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 30.08.2024.
//

import Foundation
import CoreData

@objc(TodoEntity)
public class TodoEntity: NSManagedObject { }

extension TodoEntity {

    @NSManaged public var userId: Int32
    @NSManaged public var completed: Bool
    @NSManaged public var date: String?
    @NSManaged public var todoDescription: String?
    @NSManaged public var todo: String?
    @NSManaged public var id: String

}
