//
//  ViewController.swift
//  TinyJSON
//
//  Created by liulishuo on 2022/1/26.
//

import UIKit

class ViewController: UIViewController {

    var data: TinyJSON = {
        let file = Bundle.main.path(forResource: "weibo", ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: file!))
        let tinyJSON = TinyJSON(data: jsonData)
        return tinyJSON
    }()

    @IBOutlet weak var tableView: UITableView!

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case let .array(array) = data {
            return array.count
        } else if case let .object(dict) = data {
            return dict.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            cell.detailTextLabel?.numberOfLines = 0
            cell.textLabel?.numberOfLines = 0

            if case let .array(array) = data {
                cell.textLabel?.text = "\(indexPath.row)"
                let json = array[indexPath.row]
                switch json {
                case .array, .object:
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .default
                    cell.isUserInteractionEnabled = true
                default:
                    cell.detailTextLabel?.text = json.description
                }

            } else if case let .object(dict) = data {
                let key = Array(dict.keys)[indexPath.row]
                cell.textLabel?.text = key
                let json = dict[key]
                switch json {
                case .array, .object:
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .default
                    cell.isUserInteractionEnabled = true
                default:
                    cell.detailTextLabel?.text = json?.description
                }
            } else {
                cell.textLabel?.text = data.description
            }

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if case let .array(array) = data {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                viewController.data = array[indexPath.row]
                self.navigationController?.pushViewController(viewController, animated: true)
            }

        } else if case let .object(dict) = data {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                let key = Array(dict.keys)[indexPath.row]
                if let value = dict[key] {
                    viewController.data = value
                    self.navigationController?.pushViewController(viewController, animated: true)
                }

            }
        }
    }
}
