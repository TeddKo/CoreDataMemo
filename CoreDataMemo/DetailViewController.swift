//
//  DetailViewController.swift
//  CoreDataMemo
//
//  Created by Ko Minhyuk on 5/28/25.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    
    var memo: MEMOEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo {
            contentTextView.text = memo.content
        }
    }
}
