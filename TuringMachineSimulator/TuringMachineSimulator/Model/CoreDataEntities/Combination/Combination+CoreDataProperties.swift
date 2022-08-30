//
//  Combination+CoreDataProperties.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//
//

import Foundation
import CoreData


extension Combination {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Combination> {
        return NSFetchRequest<Combination>(entityName: "Combination")
    }

    @NSManaged public var character: String?
    @NSManaged public var direction: Int64
    @NSManaged public var id: Int64
    @NSManaged public var toCharacter: String?
    @NSManaged public var option: Option?

    public var wrappedCharacter: String {
        return character ?? ""
    }
    
    public var wrappedDirection: Int {
        return Int(direction)
    }
    
    public var wrappedToCharacter: String {
        return toCharacter ?? ""
    }
    
    public var directionImage: String {
        switch wrappedDirection {
        case 0:
            return "arrow.counterclockwise"
        case 1:
            return "arrow.left"
        default:
            return "arrow.right"
        }
    }
}

extension Combination : Identifiable {

}
