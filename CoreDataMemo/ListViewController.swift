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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DataManager.shared.fetch()
        
        NotificationCenter.default.addObserver(forName: .memoDidInsert, object: nil, queue: .main) { [weak self] _ in
//            self?.memoTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            self?.memoTableView.insertRows(at: [indexPath], with: .automatic)
        }
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
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
