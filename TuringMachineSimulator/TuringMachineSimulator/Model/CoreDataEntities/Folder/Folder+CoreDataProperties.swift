//
//  Folder+CoreDataProperties.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 30.08.2022.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var name: String?
    @NSManaged public var algorithms: NSSet?

    public var wrappedName: String {
        return name ?? "New Folder"
    }
    
    public var wrappedAlgorithms: [Algorithm] {
        let algorithmSet = algorithms as? Set<Algorithm> ?? []
        return algorithmSet.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for algorithms
extension Folder {

    @objc(addAlgorithmsObject:)
    @NSManaged public func addToAlgorithms(_ value: Algorithm)

    @objc(removeAlgorithmsObject:)
    @NSManaged public func removeFromAlgorithms(_ value: Algorithm)

    @objc(addAlgorithms:)
    @NSManaged public func addToAlgorithms(_ values: NSSet)

    @objc(removeAlgorithms:)
    @NSManaged public func removeFromAlgorithms(_ values: NSSet)

}

extension Folder : Identifiable {

}
