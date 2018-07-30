//
//  AnalyticsCell.swift
//  StanwoodDebugger
//
//  Created by Tal Zion on 18/07/2018.
//

import UIKit
import StanwoodCore

class AnalyticsCell: UITableViewCell, Fillable {

    @IBOutlet private var labels: [UILabel]!
    
    private(set) var item: DebuggerAnalyticsItem?
    
    private enum Labels: Int {
        case name, category, id, contentType
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
    }
    
    func fill(with type: Type?) {
        guard let item = type as? DebuggerAnalyticsItem else { return }
        self.item = item
        labels[Labels.name.rawValue].text = item.eventName
        labels[Labels.category.rawValue].text = item.category
        labels[Labels.id.rawValue].text = item.id
        labels[Labels.contentType.rawValue].text = item.contentType
    }
    
}