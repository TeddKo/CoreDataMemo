//
//  DetailViewController.swift
//  CoreDataMemo
//
//  Created by Ko Minhyuk on 5/28/25.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    
    @IBAction func deleteMemo(_ sender: Any) {
        if let memo {
            DataManager.shared.delete(memo: memo)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true)
        }
    }
    
    var memo: MEMOEntity?
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
        }
    }
    
    var token: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo {
            contentTextView.text = memo.content
        }
        
        token = NotificationCenter.default.addObserver(forName: .memoDidUpdate, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            
            self.contentTextView.text = self.memo?.content
        }
    }
    deinit {
        
        if let token {
            NotificationCenter.default.removeObserver(token)
        }
        
        print(#function, self)
    }
}
