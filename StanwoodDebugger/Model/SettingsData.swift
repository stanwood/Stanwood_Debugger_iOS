//
//  SettingsData.swift
//  StanwoodDebugger
//
//  Created by Tal Zion on 02/08/2018.
//

import Foundation
import StanwoodCore

class SettingsData: DataType {
    
    var numberOfItems: Int {
        return sections[0].numberOfItems
    }
    
    var sections: [Section] = [
        Section(withType: .information),
        Section(withType: .data),
        Section(withType: .settings),
        Section(withType: .animation)
    ]
    
    var numberOfSections: Int {
        return sections.count
    }
    
    subscript(indexPath: IndexPath) -> Type? {
        return sections[indexPath.section].settings[indexPath.row]
    }
    
    subscript(section: Int) -> DataType {
        return sections[section]
    }
    
    func cellType(forItemAt indexPath: IndexPath) -> Fillable.Type? {
        return SettingsCell.self
    }
    
    class Section: DataType {
        
        init(withType sectionType: SectionType) {
            self.sectionType = sectionType
            
            switch sectionType {
            case .information: settings = [Setting(type: .version), Setting(type: .device)]
            case .data: settings = [Setting(type: .storeAnalytics)]
            case .settings: settings = [Setting(type: .resetAll), Setting(type: .removeData), Setting(type: .removeAnalytics)]
            case .animation: settings = [Setting(type: .bubblePulse), Setting(type: .debuggerIcons)]
            }
        }
        
        var sectionType: SectionType
        var settings: [Setting]
        
        var numberOfItems: Int {
            return settings.count
        }
        
        var numberOfSections: Int { return 1 }
        
        subscript(indexPath: IndexPath) -> Type? {
            return settings[indexPath.row]
        }
        
        subscript(section: Int) -> DataType {
            return self
        }
        
        var title: String {
            switch sectionType {
            case .data: return "Data"
            case .information: return "App Information"
            case .settings: return "Settings"
            case .animation: return "Animation"
            }
        }
        
        enum SectionType {
            case information, data, settings, animation
        }
        
        enum SettingType: String {
            case device, version, storeAnalytics, resetAll, removeData, removeAnalytics, bubblePulse, debuggerIcons
        }
        
        struct Setting: Type {
            var type: SettingType
            var id: String?
            
            var isOn: Bool {
                switch type {
                case .device, .version, .resetAll, .removeData, .removeAnalytics: return false
                case .storeAnalytics:
                    return DebuggerSettings.shouldStoreAnalyticsData
                case .bubblePulse:
                    return DebuggerSettings.isDebuggerBubblePulseAnimationEnabled
                case .debuggerIcons:
                    return DebuggerSettings.isDebuggerItemIconsAnimationEnabled
                }
            }
            
            var isSeparatorVisible: Bool = true
            var isActionable: Bool {
                switch type {
                case .device, .version, .storeAnalytics, .bubblePulse, .debuggerIcons: return false
                case .resetAll, .removeData, .removeAnalytics: return true
                }
            }
    
            var hasSwitch: Bool {
                switch type {
                case .device, .version, .resetAll, .removeData, .removeAnalytics: return false
                case .storeAnalytics, .bubblePulse, .debuggerIcons: return true
                }
            }
            
            var title: String? {
                
                let device = UIDevice.current.type.rawValue
                let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                switch type {
                case .device: return "Device \(device)"
                case .version: return "Version \(version)(\(build))"
                case .storeAnalytics: return "Save Analytics Information"
                case .resetAll: return "Restore to Default Settings"
                case .removeData: return "Delete Cached Data"
                case .removeAnalytics: return "Delete Analytics Data"
                case .bubblePulse: return "Enable Bubble Pulse Animation"
                case .debuggerIcons: return "Enable Bubble Emoji Animation"
                }
            }
            
            init(type: SettingType) {
                self.type = type
            }
        }
        
        func cellType(forItemAt indexPath: IndexPath) -> Fillable.Type? {
            return nil
        }
    }
}
