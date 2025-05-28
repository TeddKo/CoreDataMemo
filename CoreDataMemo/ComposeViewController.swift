//
//  ComposeViewController.swift
//  CoreDataMemo
//
//  Created by Ko Minhyuk on 5/28/25.
//

import UIKit

extension Notification.Name {
    static let memoDidInsert = Notification.Name("memoDidInsert")
}

class ComposeViewController: UIViewController {
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func save(_ sender: Any) {
        guard let text = contentTextView.text else {
            
            // TODO: 경고창
            return
        }
        
        DataManager.shared.insertMemo(memo: text)
        dismiss(animated: true)
    }
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
