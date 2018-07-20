//
//  FilterUIButton.swift
//  StanwoodDebugger
//
//  Created by Tal Zion on 20/07/2018.
//

import Foundation
import StanwoodCore

class FilterUIButton: UIButton {
    
    private(set) var filter: DebuggerFilterView.DebuggerFilter?
    private var badgeLabel: UILabel!
    private var badgeWidthAnchor: NSLayoutConstraint!
    private var badgeLeadingAnchor: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        badgeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        badgeLabel.layer.masksToBounds = true
        badgeLabel.layer.borderWidth = 1
        badgeLabel.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
        
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.textAlignment = .center
        badgeLabel.font = UIFont.systemFont(ofSize: 13)
        badgeLabel.text = "0"
        badgeLabel.isHidden = true
        
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addSubview(badgeLabel)
        
        badgeWidthAnchor = badgeLabel.widthAnchor.constraint(equalToConstant: 20)
        badgeLeadingAnchor = badgeLabel.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        NSLayoutConstraint.activate([
            badgeLeadingAnchor,
            badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: -5),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20),
            badgeWidthAnchor
            ])
        
        badgeLabel.layer.cornerRadius = badgeLabel.frame.width / 2
        
        NotificationCenter.default.addObservers(self, observers: Stanwood.Observer(selector: #selector(didAddNewItem(_:)), name: Notification.Name.DeuggerDidAddDebuggerItem))
    }
    
    func setTitle(_ filter: DebuggerFilterView.DebuggerFilter?) {
        self.filter = filter
        [UIControlState.normal, UIControlState.highlighted].forEach({ setTitle(filter?.rawValue, for: $0) })
    }
    
    func set(selected: Bool) {
        switch selected {
        case true:
            setTitleColor(.white, for: .normal)
            backgroundColor = StanwoodDebugger.Style.tintColor
            badgeLabel.backgroundColor = .white
            badgeLabel.textColor = StanwoodDebugger.Style.tintColor
        case false:
            setTitleColor(StanwoodDebugger.Style.tintColor, for: .normal)
            backgroundColor = .white
            badgeLabel.backgroundColor = StanwoodDebugger.Style.tintColor
            badgeLabel.textColor = .white
        }
    }
    
    @objc private func didAddNewItem(_ notification: Notification) {
        guard let addedItem = notification.object as? AddedItem,
            let type = self.filter,
            addedItem.type == type else { return }
        
        UIView.animate(withDuration: 0.3,  animations: {
            self.badgeLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { _ in
            
            let width: CGFloat = addedItem.count < 10 ? 20 : addedItem.count < 100 ? 25 : 30
            self.badgeWidthAnchor.constant = width
            let leading: CGFloat = addedItem.count > 99 ? -23 : -18
            self.badgeLeadingAnchor.constant = leading
            
            UIView.performWithoutAnimation {
                self.badgeLabel.layoutIfNeeded()
            }
            self.badgeLabel.text = "\(addedItem.count)"
            self.badgeLabel.isHidden = addedItem.count == 0
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.badgeLabel.transform = .identity
            }, completion: nil)
            
        })
    }
}
