//
//  EditableDataSource.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/26/25.
//

import UIKit

final class EditableDataSource<Section: Hashable & CaseIterable, Item: Hashable>: UITableViewDiffableDataSource<Section, Item> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
}
