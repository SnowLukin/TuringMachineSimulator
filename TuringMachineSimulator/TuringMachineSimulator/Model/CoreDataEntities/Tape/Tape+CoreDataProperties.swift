//
//  Tape+CoreDataProperties.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//
//

import Foundation
import CoreData


extension Tape {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tape> {
        return NSFetchRequest<Tape>(entityName: "Tape")
    }

    @NSManaged public var id: Int64
    @NSManaged public var alphabet: String?
    @NSManaged public var headIndex: Int64
    @NSManaged public var input: String?
    @NSManaged public var algorithm: Algorithm?
    @NSManaged public var components: NSSet?
    
    public var wrappedID: Int {
        return Int(id)
    }
    
    public var wrappedHeadIndex: Int {
        return Int(headIndex)
    }
    
    public var wrappedAlphabet: String {
        return alphabet ?? ""
    }
    
    public var wrappedInput: String {
        return input ?? ""
    }
    
    public var wrappedComponents: [TapeComponent] {
        let componentSet = components as? Set<TapeComponent> ?? []
        return componentSet.sorted {
            $0.id < $1.id
        }
    }

}

// MARK: Generated accessors for components
extension Tape {

    @objc(addComponentsObject:)
    @NSManaged public func addToComponents(_ value: TapeComponent)

    @objc(removeComponentsObject:)
    @NSManaged public func removeFromComponents(_ value: TapeComponent)

    @objc(addComponents:)
    @NSManaged public func addToComponents(_ values: NSSet)

    @objc(removeComponents:)
    @NSManaged public func removeFromComponents(_ values: NSSet)

}

extension Tape : Identifiable {

}
