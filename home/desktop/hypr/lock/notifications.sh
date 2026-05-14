#!/bin/bash

ICON_NONE="󰂚"
ICON_NOTIFICATIONS="󱅫"
ICON_DND="󱏩"

NOTIFICATION_COUNT=$(swaync-client -c)
DND_STATE=$(swaync-client -D 2>/dev/null || echo "false")

if [ "$DND_STATE" = "true" ]; then
    ICON="$ICON_DND"

elif [ "$NOTIFICATION_COUNT" -gt 0 ]; then
    ICON="$ICON_NOTIFICATIONS"

else
    ICON="$ICON_NONE"
fi

echo "$ICON  $NOTIFICATION_COUNT"
