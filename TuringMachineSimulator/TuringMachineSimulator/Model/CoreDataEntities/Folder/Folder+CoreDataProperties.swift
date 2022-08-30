//
//  Folder+CoreDataProperties.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var name: String?
    @NSManaged public var parentFolder: Folder?
    @NSManaged public var subFolders: NSSet?
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
    
    public var wrappedSubFolders: [Folder] {
        let subFolderSet = subFolders as? Set<Folder> ?? []
        return Array(subFolderSet)
    }

}

// MARK: Generated accessors for subFolders
extension Folder {

    @objc(addSubFoldersObject:)
    @NSManaged public func addToSubFolders(_ value: Folder)

    @objc(removeSubFoldersObject:)
    @NSManaged public func removeFromSubFolders(_ value: Folder)

    @objc(addSubFolders:)
    @NSManaged public func addToSubFolders(_ values: NSSet)

    @objc(removeSubFolders:)
    @NSManaged public func removeFromSubFolders(_ values: NSSet)

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
