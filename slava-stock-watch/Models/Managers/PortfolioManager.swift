//
//  PortfolioManager.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/29/22.
//

import Foundation
import CoreData

class PortfolioManager : ManagerBase, IPortfolioManager{
    
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
        return ExecuteDelete(url: url)
    }
    
    func GetPortfolioFiles() -> [PortfolioFile]{
        let req : NSFetchRequest<PortfolioFile> = PortfolioFile.fetchRequest()
        return ExecuteFetch(req)
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
}
