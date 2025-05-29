//
//  ViewController.swift
//  CoreDataMemo
//
//  Created by Ko Minhyuk on 5/28/25.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var memoTableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let cell = sender as? UITableViewCell {
            if let indexPath = memoTableView.indexPath(for: cell) {
                if let vc = segue.destination as? DetailViewController {
                    vc.memo = DataManager.shared.list[indexPath.row]
                }
            }
        }
    }
    
    var reloadTargetIndexPath: IndexPath?
    var token: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DataManager.shared.fetch()
        
        token = NotificationCenter.default.addObserver(forName: .memoDidInsert, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            self.memoTableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        token = NotificationCenter.default.addObserver(forName: .memoDidUpdate, object: nil, queue: .main) { [weak self] noti in
            
            guard let self else { return }
            
            if let memo = noti.userInfo?["memo"] as? MEMOEntity {
                if let index = DataManager.shared.list.firstIndex(of: memo) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.reloadTargetIndexPath = indexPath
//                    self?.memoTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        token = NotificationCenter.default.addObserver(forName: .memoDidDelete, object: nil, queue: .main) { [weak self] noti in
            
            guard let self else { return }
            
            if let memo = noti.userInfo?["memo"] as? MEMOEntity {
                if let index = DataManager.shared.list.firstIndex(of: memo) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.memoTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        if let reloadTargetIndexPath {
            memoTableView.reloadRows(at: [reloadTargetIndexPath], with: .automatic)
            self.reloadTargetIndexPath = nil
        }
    }
    
    deinit {
        
        if let token {
            NotificationCenter.default.removeObserver(token)
        }
        
        print(#function, self)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let target = DataManager.shared.list[indexPath.row]
        
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = target.insertDate?.formatted()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
