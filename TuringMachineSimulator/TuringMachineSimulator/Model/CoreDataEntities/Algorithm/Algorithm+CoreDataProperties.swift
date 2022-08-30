//
//  Algorithm+CoreDataProperties.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//
//

import Foundation
import CoreData


extension Algorithm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Algorithm> {
        return NSFetchRequest<Algorithm>(entityName: "Algorithm")
    }

    @NSManaged public var name: String?
    @NSManaged public var algDescription: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var editDate: Date?
    @NSManaged public var pinned: Bool
    @NSManaged public var folder: Folder?
    @NSManaged public var tapes: NSSet?
    @NSManaged public var states: NSSet?
    
    public var wrappedName: String {
        return name ?? "New Algorithm"
    }
    
    public var wrappedDescription: String {
        return algDescription ?? ""
    }
    
    public var wrappedCreationDate: Date {
        return creationDate ?? Date.now
    }
    
    public var wrappedEditDate: Date {
        return editDate ?? Date.now
    }
    
    public var wrappedTapes: [Tape] {
        let tapeSet = tapes as? Set<Tape> ?? []
        return tapeSet.sorted {
            $0.id < $1.id
        }
    }

    public var wrappedStates: [StateQ] {
        let stateSet = states as? Set<StateQ> ?? []
        return stateSet.sorted {
            $0.id < $1.id
        }
    }
}

// MARK: Generated accessors for tapes
extension Algorithm {

    @objc(addTapesObject:)
    @NSManaged public func addToTapes(_ value: Tape)

    @objc(removeTapesObject:)
    @NSManaged public func removeFromTapes(_ value: Tape)

    @objc(addTapes:)
    @NSManaged public func addToTapes(_ values: NSSet)

    @objc(removeTapes:)
    @NSManaged public func removeFromTapes(_ values: NSSet)

}

// MARK: Generated accessors for states
extension Algorithm {

    @objc(addStatesObject:)
    @NSManaged public func addToStates(_ value: StateQ)

    @objc(removeStatesObject:)
    @NSManaged public func removeFromStates(_ value: StateQ)

    @objc(addStates:)
    @NSManaged public func addToStates(_ values: NSSet)

    @objc(removeStates:)
    @NSManaged public func removeFromStates(_ values: NSSet)

}

extension Algorithm : Identifiable {

}
