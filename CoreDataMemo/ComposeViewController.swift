//
//  ComposeViewController.swift
//  CoreDataMemo
//
//  Created by Ko Minhyuk on 5/28/25.
//

import UIKit

extension Notification.Name {
    static let memoDidInsert = Notification.Name("memoDidInsert")
    static let memoDidUpdate = Notification.Name("memoDidUpdate")
    static let memoDidDelete = Notification.Name("memoDidDelete")
}

class ComposeViewController: UIViewController {
    
    var editTarget: MEMOEntity? // nil이면 쓰기, 아니면 편집
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func save(_ sender: Any) {
        guard let text = contentTextView.text else {
            
            // TODO: 경고창
            return
        }
        
        if let editTarget {
            DataManager.shared.updateMemo(memo: editTarget, with: text)
        } else {
            DataManager.shared.insertMemo(memo: text)
        }

        dismiss(animated: true)
    }
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let editTarget {
            navigationItem.title = "편집"
            contentTextView.text = editTarget.content
        } else {
            navigationItem.title = "새 메모"
        }
        
        contentTextView.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
    deinit {
        print(#function, self)
    }
}
