//
//  ConversationView+FRCDelegate.swift
//  ChatApp
//
//  Created by Иван Лебедев on 10/04/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import CoreData
import Foundation

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        tableView.reloadSectionIndexTitles()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let nip = newIndexPath {
                tableView.insertRows(at: [nip], with: .automatic)
            }
        case .move:
            if let nip = newIndexPath,
                let ip = indexPath {
                tableView.deleteRows(at: [ip], with: .automatic)
                tableView.insertRows(at: [nip], with: .automatic)
            }
        case .update:
            if let ip = indexPath {
                tableView.reloadRows(at: [ip], with: .automatic)
            }
        case .delete:
            if let ip = indexPath {
                tableView.deleteRows(at: [ip], with: .automatic)
            }
        }
        self.toBottom()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
        self.toBottom()
    }
}
