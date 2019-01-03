//
//  ViewController.swift
//  toot
//
//  Created by ryosuke kubo on 2019/01/03.
//  Copyright © 2019 ryosuke kubo. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ViewController: UIViewController {

    var tootTable: UITableView!
    var tootArray:[String] = []
    var realm: Realm!
    var results: Results<TootDB>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tootTable = UITableView(frame: view.frame)
        tootTable.delegate = self
        tootTable.dataSource = self
        view.addSubview(tootTable)
        
        self.navigationController?.title = "Toot"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.showAlert))
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        realm = try! Realm()
        results = realm.objects(TootDB.self)
        print(realm.configuration.fileURL!)
        


    }
    
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
        tootTable.reloadData()
    }

    @objc func showAlert(){
        let alert = UIAlertController(title: "toot", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { Void in
    
        })
        let alertAddBtn = UIAlertAction(title: "add", style: UIAlertAction.Style.default, handler: { Void in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            self.addToot(toot: text)
            self.tootTable.reloadData()

        })
        
        alert.addAction(alertAddBtn)
        present(alert, animated: true, completion: nil)
    }
    
    func addToot(toot: String){
        try! self.realm.write {
            self.realm.add(TootDB(value: ["toot": toot]))
        }
    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = results else {
            return 0
        }
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = results[indexPath.row].toot
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tootTable.isEditing = editing
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        try! realm.write {
            realm.delete(results[indexPath.row])
        }
        tootTable.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell row \(indexPath)")
    }
}
