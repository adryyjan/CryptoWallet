//
//  PortfolioDataService.swift
//  CryptoWallet
//
//  Created by Adrian Mazek on 02/09/2025.
//

import Foundation
import CoreData

final class PortfolioDataService {
    
    
    private let container: NSPersistentContainer
    private let conteinerName: String = "PortfolioContainer"
    private let portfolioEntityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: conteinerName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            self.getPortfolio()
        }
    }
    
    //MARK: - PUBLIC
    
    func updatePortfolio(coin: CoinModel, ammount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if ammount > 0 {
                update(entity: entity, amount: ammount)
                print("updated \(ammount)")
            } else {
                remove(entity: entity)
            }
        }else {
            add(coin: coin, ammount: ammount)
        }
        
        
    }
    
    
    //MARK: - PRIVATE
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: portfolioEntityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private func add(coin: CoinModel, ammount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.ammount = ammount
        applyChanges()
        
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.ammount = amount
        applyChanges()
    }
    
    private func remove(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
