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
    
    func SavePortfolioFile(id : String, name : String, value : Double, shares : Int, url : URL?) -> Bool{
        let fileOpt = TryGetPortfolioFileByUrl(url)
        let file = fileOpt ?? PortfolioFile(context: container.viewContext)
        file.id = id
        file.name = name
        file.avgPrice = value
        file.shares = Int64(shares)
        return TrySave()
    }
    
    func DeletePortfolioFile(url : URL?) -> Bool{
        let fileOpt = TryGetFileByUrl(url)
        guard let file = fileOpt else{
            return false
        }
        container.viewContext.delete(file)
        return true
    }
    
    func GetPortfolioFiles() -> [PortfolioFile]{
        let req : NSFetchRequest<PortfolioFile> = PortfolioFile.fetchRequest()
        do{
            return try container.viewContext.fetch(req)
        } catch{
            return []
        }
    }
    
    private func TryGetFileByUrl(_ urlOpt : URL?) -> NSManagedObject? {
        guard let url = urlOpt else{
            return nil
        }
        let objIDOpt = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url)
        guard let objID = objIDOpt else{
            return nil
        }
        do{
            return try container.viewContext.existingObject(with: objID)
        } catch{
            return nil
        }
    }
    func TryGetPortfolioFileByUrl(_ urlOpt : URL?) -> PortfolioFile?{
        return TryGetFileByUrl(urlOpt) as? PortfolioFile
    }
    
    
    func GetPortfolioCash() -> PortfolioCashFile? {
        let req : NSFetchRequest<PortfolioCashFile> = PortfolioCashFile.fetchRequest()
        do{
            let cashOpt = try container.viewContext.fetch(req).first
            guard let cash = cashOpt else {
                return nil
            }
            return cash
        } catch {
            return nil
        }
    }
    
    func UpdatePortfolioCash(money: Double, urlOpt: URL?) -> PortfolioCashFile?{
        guard let _ = urlOpt else{
            CreatePortfolioCash(initValue: money) //SHOULD NOT GET HERE BOZO
            return GetPortfolioCash()
        }
        let cashOpt = TryGetFileByUrl(urlOpt) as? PortfolioCashFile
        guard let cash = cashOpt else {
            return nil //ALSO your shits fucked if youre here
        }
        cash.cash = money
        _ = TrySave()
        return cash
    }
    
    func CreatePortfolioCash(initValue : Double) {
        //SO DUMB that we have to create this
        //BUT no easy way to initialize a DataModel locally
        let cash = PortfolioCashFile(context: container.viewContext)
        cash.cash = initValue
        _ = TrySave()
    }
    
    func Reset(){
        TryDelete("PortfolioCashFile")
        TryDelete("PortfolioFile")
    }
    
    func TryDelete(_ name : String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try container.viewContext.execute(deleteRequest)
        } catch{
            print("Failed to reset for \(name) entity : \(error)")
        }
    }
    
    
    private func TrySave() -> Bool{
        do{
            try container.viewContext.save()
            return true
        } catch {
            print("Failed to save with error: \(error)")
            return false
        }
    }
}
