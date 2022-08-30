//
//  TapeComponent+CoreDataProperties.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//
//

import Foundation
import CoreData


extension TapeComponent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TapeComponent> {
        return NSFetchRequest<TapeComponent>(entityName: "TapeComponent")
    }

    @NSManaged public var id: Int64
    @NSManaged public var value: String?
    @NSManaged public var tape: Tape?
    
    public var wrappedID: Int {
        return Int(id)
    }
    public var wrappedValue: String {
        return value ?? "_"
    }

}

extension TapeComponent : Identifiable {

}
