//
// aus der Technik, on 17.05.23.
// https://www.ausdertechnik.de
//

import Foundation

public enum FileChangeEvent {
    case added(file: URL)
    case deleted(file: URL)
    case changed(file: URL)
    case directoryAdded(file: URL)
    case directoryDeleted(file: URL)
    case directoryChanged(file: URL)

    // Display friendly description of the event
    public var description: String {
        get {
            switch self {
            case .added(file: let file):
                return "Added:    \(file.path)"
            case .deleted(file: let file):
                return "Deleted:  \(file.path)"
            case .changed(file: let file):
                return "Modified: \(file.path)"
            
            case .directoryAdded(file: let file):
                return "Directory Added:    \(file.path)"
            case .directoryDeleted(file: let file):
                return "Directory Deleted:  \(file.path)"
            case .directoryChanged(file: let file):
                return "Directory Changed:  \(file.path)"

            }
        }
    }
}
