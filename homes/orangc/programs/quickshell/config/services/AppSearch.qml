pragma Singleton

import "root:/modules/common/functions/fuzzysort.js" as Fuzzy
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property list<DesktopEntry> list: Array.from(DesktopEntries.applications.values)
        .sort((a, b) => a.name.localeCompare(b.name))
    readonly property var preppedNames: list.map(a => ({
                name: Fuzzy.prepare(`${a.name} `),
                entry: a
            }))

    function fuzzyQuery(search: string): var { // Idk why list<DesktopEntry> doesn't work
        return Fuzzy.go(search, preppedNames, {
            all: true,
            key: "name"
        }).map(r => {
            return r.obj.entry
    });
    }
}
