//
//  ActionSheet.swift
//  Core
//
//  Created by 강현준 on 12/12/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public class ActionSheet {

    public static func baseActionSheet(
        source: UIViewController,
        title: String,
        content: [String],
        onSelect: @escaping ((String) -> ())
    ) {

        let actionSheet = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)

        content.forEach { item in

            let action = UIAlertAction(title: item, style: .default, handler: { (result) in
                onSelect(item)
            })
            
            actionSheet.addAction(action)
        }

        let cancleAction = UIAlertAction(title: "취소", style: .cancel)

        actionSheet.addAction(cancleAction)

        source.present(actionSheet, animated: true)
    }
}
