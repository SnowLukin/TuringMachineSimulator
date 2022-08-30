//
//  StateQ+CoreDataProperties.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//
//

import Foundation
import CoreData


extension StateQ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StateQ> {
        return NSFetchRequest<StateQ>(entityName: "StateQ")
    }

    @NSManaged public var id: Int64
    @NSManaged public var isForReset: Bool
    @NSManaged public var isStarting: Bool
    @NSManaged public var algorithm: Algorithm?
    @NSManaged public var options: NSSet?
    @NSManaged public var fromOptions: NSSet?
    
    public var wrappedID: Int {
        return Int(id)
    }
    
    public var wrappedOptions: [Option] {
        let optionSet = options as? Set<Option> ?? []
        return optionSet.sorted {
            $0.id < $1.id
        }
    }
    
    public var wrappedFromOptions: [Option] {
        let fromOptionSet = fromOptions as? Set<Option> ?? []
        return fromOptionSet.sorted {
            $0.id < $1.id
        }
    }

}

// MARK: Generated accessors for options
extension StateQ {

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: Option)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: Option)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSSet)

}

// MARK: Generated accessors for fromOptions
extension StateQ {

    @objc(addFromOptionsObject:)
    @NSManaged public func addToFromOptions(_ value: Option)

    @objc(removeFromOptionsObject:)
    @NSManaged public func removeFromFromOptions(_ value: Option)

    @objc(addFromOptions:)
    @NSManaged public func addToFromOptions(_ values: NSSet)

    @objc(removeFromOptions:)
    @NSManaged public func removeFromFromOptions(_ values: NSSet)

}

extension StateQ : Identifiable {

}
