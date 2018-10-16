//
//  MainTVC.swift
//  Collector
//
//  Created by David E Bratton on 10/15/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit

class MainTVC: UITableViewController {

    var collectables = [Collectable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCollectablesFromCD()
    }
    
    func getCollectablesFromCD() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let collectablesFromCD = try? context.fetch(Collectable.fetchRequest()) {
                if let items = collectablesFromCD as? [Collectable] {
                    collectables = items
                    tableView.reloadData()
                }
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return collectables.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath)

        let cell = UITableViewCell()
        let currentItem = collectables[indexPath.row]
        // Have to reconvert Binary Data to UIImage
        if let data = currentItem.image {
            cell.imageView?.image = UIImage(data: data)
        }
        
        cell.textLabel?.text = currentItem.title

        return cell
    }
    
    // When click on row, makes the grey selection go away
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let itemToDelete = collectables[indexPath.row]
                context.delete(itemToDelete)
                // Still have to save even though we deleted
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
            getCollectablesFromCD()
        }
    }
}
