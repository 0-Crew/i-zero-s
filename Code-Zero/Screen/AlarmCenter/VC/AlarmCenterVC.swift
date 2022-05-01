//
//  AlarmCenterVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/04/26.
//

import UIKit

class AlarmCenterVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension AlarmCenterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlarmCell = tableView.dequeueCell(indexPath: indexPath)
        return cell
    }

}
