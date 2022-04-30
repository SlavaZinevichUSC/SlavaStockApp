//
//  PortfolioManager.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/29/22.
//

import Foundation
import CoreData

class PortfolioManager : IPortfolioManager{
    
    let container : NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores{ (description, error) in
            if let e = error {
                fatalError("Failed to load Data Model: \(e.localizedDescription)")
            }
        }
    }
    
    func SavePortfolioFile(id : String, name : String, value : Double){
        let file = PortfolioFile(context: container.viewContext)
        file.id = id
        file.name = name
        file.avgPrice = value
        TrySave()
    }
    
    func GetPortfolioFiles() -> [PortfolioFile]{
        let req : NSFetchRequest<PortfolioFile> = PortfolioFile.fetchRequest()
        do{
            return try container.viewContext.fetch(req)
        } catch{
            return []
        }
    }
    
    
    private func TrySave(){
        do{
            try container.viewContext.save()
        } catch {
            print("Failed to save with error: \(error)")
        }
    }
}
