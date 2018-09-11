//
//  AddItemViewControllerDelegate.swift
//  BucketList
//
//  Created by Quang Nguyen on 9/8/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func itemSaved(by controller: AddItemViewController,
                   withObjective objective: String,
                   at indexPath: IndexPath?)
    func cancelButtonPressed(by controller: AddItemViewController)
}
