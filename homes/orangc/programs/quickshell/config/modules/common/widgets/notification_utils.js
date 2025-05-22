

function findSuitableMaterialSymbol(summary = "") {
    const defaultType = 'chat';
    if(summary.length === 0) return defaultType;

    const keywordsToTypes = {
        'reboot': 'restart_alt',
        'recording': 'screen_record',
        'battery': 'power',
        'power': 'power',
        'screenshot': 'screenshot_monitor',
        'welcome': 'waving_hand',
        'time': 'scheduleb',
        'installed': 'download',
        'configuration reloaded': 'reset_wrench',
        'config': 'reset_wrench',
        'update': 'update',
        'ai response': 'neurology',
        'startswith:file': 'folder_copy', // Declarative startsWith check
    };

    const lowerSummary = summary.toLowerCase();

    for (const [keyword, type] of Object.entries(keywordsToTypes)) {
        if (keyword.startsWith('startswith:')) {
            const startsWithKeyword = keyword.replace('startswith:', '');
            if (lowerSummary.startsWith(startsWithKeyword)) {
                return type;
            }
        } else if (lowerSummary.includes(keyword)) {
            return type;
        }
    }

    return defaultType;
}

// const getFriendlyNotifTimeString = (timeObject) => {
//     const messageTime = GLib.DateTime.new_from_unix_local(timeObject);
//     const oneMinuteAgo = GLib.DateTime.new_now_local().add_seconds(-60);
//     if (messageTime.compare(oneMinuteAgo) > 0)
//         return getString('Now');
//     else if (messageTime.get_day_of_year() == GLib.DateTime.new_now_local().get_day_of_year())
//         return messageTime.format(userOptions.time.format);
//     else if (messageTime.get_day_of_year() == GLib.DateTime.new_now_local().get_day_of_year() - 1)
//         return getString('Yesterday');
//     else
//         return messageTime.format(userOptions.time.dateFormat);
// }

const getFriendlyNotifTimeString = (timestamp) => {
    const messageTime = new Date(timestamp);
    const now = new Date();
    const oneMinuteAgo = new Date(now.getTime() - 60000);

    if (messageTime > oneMinuteAgo) 
        return 'Now';
    if (messageTime.toDateString() === now.toDateString())
        return Qt.formatDateTime(messageTime, "hh:mm");
    if (messageTime.toDateString() === new Date(now.getTime() - 86400000).toDateString()) 
        return 'Yesterday';
    return Qt.formatDateTime(messageTime, "MMMM dd");
};
