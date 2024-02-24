//
// aus der Technik, on 15.05.23.
// https://www.ausdertechnik.de
//

import Foundation
import FileMonitorShared
#if canImport(CInotify)
import CInotify
#endif

#if os(Linux)
public struct LinuxWatcher: WatcherProtocol {
    var fsWatcher: FileSystemWatcher
    public var delegate: WatcherDelegate?
    var path: URL

    public init(directory: URL) {
        fsWatcher = FileSystemWatcher()
        path = directory
    }

    public func observe() throws {
        fsWatcher.watch(path: self.path.path, for: InotifyEventMask.inAllEvents) { fsEvent in
            //print("Mask: 0x\(String(format: "%08x", fsEvent.mask))")
            guard let url = URL(string: self.path.path + "/" + fsEvent.name) else { return }

            // Ignore directory changes
            // if fsEvent.mask & InotifyEventMask.inIsDir.rawValue > 0 { return }

            var urlEvent: FileChangeEvent? = nil

            // File was changed
            if fsEvent.mask & InotifyEventMask.inModify.rawValue > 0
                || fsEvent.mask & InotifyEventMask.inMoveSelf.rawValue > 0
            {
                urlEvent = FileChangeEvent.changed(file: url)
            }
            // File added
            else if fsEvent.mask & InotifyEventMask.inCreate.rawValue > 0
                || fsEvent.mask & InotifyEventMask.inMovedTo.rawValue > 0
            {
                urlEvent = FileChangeEvent.added(file: url)
            }
            // File removed
            else if fsEvent.mask & InotifyEventMask.inDelete.rawValue > 0
                || fsEvent.mask & InotifyEventMask.inDeleteSelf.rawValue > 0
                || fsEvent.mask & InotifyEventMask.inMovedFrom.rawValue > 0
            {
                urlEvent = FileChangeEvent.deleted(file: url)
            }

            if urlEvent == nil  {
                return
            }

            self.delegate?.fileDidChanged(event: urlEvent!)
        }

        fsWatcher.start()
    }

    public func stop() {
        fsWatcher.stop()
    }
}
#endif
