//
//  ManagerBase.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import Foundation
import CoreData

class ManagerBase{
    let container : NSPersistentContainer
    
    init(_ container : NSPersistentContainer){
        self.container = container
    }
    
    func ExecuteFetch<T>(_ req : NSFetchRequest<T>) -> [T]{
        do{
            return try container.viewContext.fetch(req)
        } catch{
            return []
        }
    }
    
    func ExecuteDelete(url : URL?) -> Bool{
        let fileOpt = TryGetFileByUrl(url)
        guard let file = fileOpt else{
            return false
        }
        container.viewContext.delete(file)
        _ = TrySave()
        return true
    }
    
    func ExecuteDeletes(urls : [URL?]){ //not good -> should batch delete but who cares
        for url in urls{
            _ = ExecuteDelete(url: url)
        }
    }
    
    func TryGetFileByUrl(_ urlOpt : URL?) -> NSManagedObject? {
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
    
    func TrySave() -> Bool{
        do{
            try container.viewContext.save()
            return true
        } catch {
            print("Failed to save with error: \(error)")
            return false
        }
    }
    
    func TryDelete(_ name : String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try container.viewContext.execute(deleteRequest)
            _ = TrySave()
        } catch{
            print("Failed to reset for \(name) entity : \(error)")
        }
    }
}
