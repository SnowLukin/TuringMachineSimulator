//
//  Option+CoreDataProperties.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//
//

import Foundation
import CoreData


extension Option {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Option> {
        return NSFetchRequest<Option>(entityName: "Option")
    }

    @NSManaged public var id: Int64
    @NSManaged public var state: StateQ?
    @NSManaged public var combinations: NSSet?
    @NSManaged public var toState: StateQ?

    public var wrappedID: Int {
        return Int(id)
    }
    
    public var wrappedCombinations: [Combination] {
        let combinationSet = combinations as? Set<Combination> ?? []
        return combinationSet.sorted {
            $0.id < $1.id
        }
    }
}

// MARK: Generated accessors for combinations
extension Option {

    @objc(addCombinationsObject:)
    @NSManaged public func addToCombinations(_ value: Combination)

    @objc(removeCombinationsObject:)
    @NSManaged public func removeFromCombinations(_ value: Combination)

    @objc(addCombinations:)
    @NSManaged public func addToCombinations(_ values: NSSet)

    @objc(removeCombinations:)
    @NSManaged public func removeFromCombinations(_ values: NSSet)

}

extension Option : Identifiable {

}
