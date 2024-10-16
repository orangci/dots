{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.vencord = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    home.file = {
      ".config/Vencord/themes/orangetweaks.css".source = ../../files/vencordthemes/orangetweaks.css;
      ".config/Vencord/themes/catppuccin.css".source = ../../files/vencordthemes/catppuccin.css;
      ".config/Vencord/settings/settings.json".text = ''
        {
            "autoUpdate": true,
            "autoUpdateNotification": true,
            "useQuickCss": true,
            "themeLinks": [],
            "enabledThemes": [
                "catppuccin.css",
                "orangetweaks.css"
            ],
            "enableReactDevtools": false,
            "frameless": false,
            "transparent": false,
            "winCtrlQ": false,
            "disableMinSize": false,
            "winNativeTitleBar": false,
            "plugins": {
                "ChatInputButtonAPI": {
                    "enabled": true
                },
                "CommandsAPI": {
                    "enabled": true
                },
                "MemberListDecoratorsAPI": {
                    "enabled": true
                },
                "MessageAccessoriesAPI": {
                    "enabled": true
                },
                "MessageDecorationsAPI": {
                    "enabled": true
                },
                "MessageEventsAPI": {
                    "enabled": true
                },
                "MessagePopoverAPI": {
                    "enabled": true
                },
                "MessageUpdaterAPI": {
                    "enabled": true
                },
                "ServerListAPI": {
                    "enabled": false
                },
                "UserSettingsAPI": {
                    "enabled": true
                },
                "AccountPanelServerProfile": {
                    "enabled": false
                },
                "AlwaysAnimate": {
                    "enabled": false
                },
                "AlwaysExpandRoles": {
                    "enabled": true
                },
                "AlwaysTrust": {
                    "enabled": true,
                    "domain": true,
                    "file": true
                },
                "AnonymiseFileNames": {
                    "enabled": true,
                    "anonymiseByDefault": true,
                    "method": 1,
                    "randomisedLength": 1,
                    "consistent": "image"
                },
                "AppleMusicRichPresence": {
                    "enabled": false
                },
                "BANger": {
                    "enabled": false,
                    "source": "https://i.imgur.com/wp5q52C.mp4"
                },
                "BetterFolders": {
                    "enabled": false,
                    "sidebar": true,
                    "sidebarAnim": true,
                    "closeAllFolders": false,
                    "closeAllHomeButton": false,
                    "closeOthers": false,
                    "forceOpen": false,
                    "keepIcons": false,
                    "showFolderIcon": 1
                },
                "BetterGifAltText": {
                    "enabled": false
                },
                "BetterGifPicker": {
                    "enabled": true
                },
                "BetterNotesBox": {
                    "enabled": false,
                    "hide": false,
                    "noSpellCheck": false
                },
                "BetterRoleContext": {
                    "enabled": true,
                    "roleIconFileFormat": "png"
                },
                "BetterRoleDot": {
                    "enabled": false
                },
                "BetterSessions": {
                    "enabled": false
                },
                "BetterSettings": {
                    "enabled": true,
                    "disableFade": true,
                    "organizeMenu": true,
                    "eagerLoad": true
                },
                "BetterUploadButton": {
                    "enabled": true
                },
                "BiggerStreamPreview": {
                    "enabled": true
                },
                "BlurNSFW": {
                    "enabled": true,
                    "blurAmount": 10
                },
                "CallTimer": {
                    "enabled": true,
                    "format": "stopwatch"
                },
                "ClearURLs": {
                    "enabled": false
                },
                "ClientTheme": {
                    "enabled": false
                },
                "ColorSighted": {
                    "enabled": false
                },
                "ConsoleJanitor": {
                    "enabled": true,
                    "disableLoggers": true,
                    "disableSpotifyLogger": true,
                    "whitelistedLoggers": "GatewaySocket; Routing/Utils"
                },
                "ConsoleShortcuts": {
                    "enabled": true
                },
                "CopyEmojiMarkdown": {
                    "enabled": true,
                    "copyUnicode": true
                },
                "CopyFileContents": {
                    "enabled": true
                },
                "CopyUserURLs": {
                    "enabled": false
                },
                "CrashHandler": {
                    "enabled": true
                },
                "CtrlEnterSend": {
                    "enabled": false
                },
                "CustomRPC": {
                    "enabled": false
                },
                "CustomIdle": {
                    "enabled": false,
                    "idleTimeout": 10,
                    "remainInIdle": true
                },
                "Dearrow": {
                    "enabled": false,
                    "hideButton": false,
                    "replaceElements": 0,
                    "dearrowByDefault": true
                },
                "Decor": {
                    "enabled": false
                },
                "DisableCallIdle": {
                    "enabled": false
                },
                "DontRoundMyTimestamps": {
                    "enabled": false
                },
                "EmoteCloner": {
                    "enabled": true
                },
                "Experiments": {
                    "enabled": true,
                    "toolbarDevMenu": true
                },
                "F8Break": {
                    "enabled": false
                },
                "FakeNitro": {
                    "enabled": true,
                    "enableEmojiBypass": true,
                    "emojiSize": 48,
                    "transformEmojis": true,
                    "enableStickerBypass": true,
                    "stickerSize": 160,
                    "transformStickers": true,
                    "transformCompoundSentence": false,
                    "enableStreamQualityBypass": true,
                    "useHyperLinks": true,
                    "hyperLinkText": "{{NAME}}",
                    "disableEmbedPermissionCheck": false
                },
                "FakeProfileThemes": {
                    "enabled": false,
                    "nitroFirst": true
                },
                "FavoriteEmojiFirst": {
                    "enabled": true
                },
                "FavoriteGifSearch": {
                    "enabled": true
                },
                "FixCodeblockGap": {
                    "enabled": true
                },
                "FixSpotifyEmbeds": {
                    "enabled": true,
                    "volume": 10
                },
                "FixYoutubeEmbeds": {
                    "enabled": true
                },
                "ForceOwnerCrown": {
                    "enabled": true
                },
                "FriendInvites": {
                    "enabled": true
                },
                "FriendsSince": {
                    "enabled": false
                },
                "FullSearchContext": {
                    "enabled": true
                },
                "GameActivityToggle": {
                    "enabled": true,
                    "oldIcon": false
                },
                "GifPaste": {
                    "enabled": true
                },
                "GreetStickerPicker": {
                    "enabled": true
                },
                "HideAttachments": {
                    "enabled": true
                },
                "iLoveSpam": {
                    "enabled": false
                },
                "IgnoreActivities": {
                    "enabled": false,
                    "listMode": 0,
                    "idsList": "",
                    "ignorePlaying": false,
                    "ignoreStreaming": false,
                    "ignoreListening": false,
                    "ignoreWatching": false,
                    "ignoreCompeting": false
                },
                "ImageLink": {
                    "enabled": false
                },
                "ImageZoom": {
                    "enabled": false
                },
                "ImplicitRelationships": {
                    "enabled": false
                },
                "InvisibleChat": {
                    "enabled": false
                },
                "KeepCurrentChannel": {
                    "enabled": false
                },
                "LastFMRichPresence": {
                    "enabled": false
                },
                "LoadingQuotes": {
                    "enabled": false,
                    "replaceEvents": true,
                    "enablePluginPresetQuotes": true,
                    "enableDiscordPresetQuotes": false,
                    "additionalQuotes": "People die when they're killed.| Water is wet.",
                    "additionalQuotesDelimiter": "|"
                },
                "MemberCount": {
                    "enabled": true,
                    "toolTip": true,
                    "memberList": true
                },
                "MentionAvatars": {
                    "enabled": true,
                    "showAtSymbol": true
                },
                "MessageClickActions": {
                    "enabled": true,
                    "enableDeleteOnClick": true,
                    "enableDoubleClickToEdit": true,
                    "enableDoubleClickToReply": true,
                    "requireModifier": false
                },
                "MessageLatency": {
                    "enabled": false
                },
                "MessageLinkEmbeds": {
                    "enabled": true,
                    "automodEmbeds": "prefer",
                    "listMode": "blacklist",
                    "idList": "",
                    "messageBackgroundColor": false
                },
                "MessageLogger": {
                    "enabled": true,
                    "deleteStyle": "overlay",
                    "logDeletes": true,
                    "collapseDeleted": false,
                    "logEdits": true,
                    "inlineEdits": false,
                    "ignoreBots": false,
                    "ignoreSelf": false,
                    "ignoreUsers": "",
                    "ignoreChannels": "",
                    "ignoreGuilds": ""
                },
                "MessageTags": {
                    "enabled": true,
                    "clyde": true
                },
                "MoreCommands": {
                    "enabled": false
                },
                "MoreKaomoji": {
                    "enabled": false
                },
                "MoreUserTags": {
                    "enabled": true,
                    "tagSettings": {
                        "WEBHOOK": {
                            "text": "Webhook",
                            "showInChat": true,
                            "showInNotChat": true
                        },
                        "OWNER": {
                            "text": "Owner",
                            "showInChat": true,
                            "showInNotChat": true
                        },
                        "ADMINISTRATOR": {
                            "text": "Admin",
                            "showInChat": true,
                            "showInNotChat": true
                        },
                        "MODERATOR_STAFF": {
                            "text": "Staff",
                            "showInChat": true,
                            "showInNotChat": true
                        },
                        "MODERATOR": {
                            "text": "Mod",
                            "showInChat": true,
                            "showInNotChat": true
                        },
                        "VOICE_MODERATOR": {
                            "text": "VC Mod",
                            "showInChat": true,
                            "showInNotChat": true
                        },
                        "CHAT_MODERATOR": {
                            "text": "Chat Mod",
                            "showInChat": true,
                            "showInNotChat": true
                        }
                    },
                    "dontShowBotTag": false,
                    "dontShowForBots": true
                },
                "Moyai": {
                    "enabled": false
                },
                "MutualGroupDMs": {
                    "enabled": false
                },
                "NewGuildSettings": {
                    "enabled": true,
                    "guild": true,
                    "messages": 1,
                    "everyone": false,
                    "role": false,
                    "highlights": true,
                    "events": true,
                    "showAllChannels": false
                },
                "NoBlockedMessages": {
                    "enabled": false
                },
                "NoDevtoolsWarning": {
                    "enabled": false
                },
                "NoF1": {
                    "enabled": false
                },
                "NoMaskedUrlPaste": {
                    "enabled": false
                },
                "NoMosaic": {
                    "enabled": false,
                    "inlineVideo": true
                },
                "NoOnboardingDelay": {
                    "enabled": true
                },
                "NoPendingCount": {
                    "enabled": false,
                    "hideFriendRequestsCount": false,
                    "hideMessageRequestsCount": false,
                    "hidePremiumOffersCount": true
                },
                "NoProfileThemes": {
                    "enabled": false
                },
                "NoRPC": {
                    "enabled": false
                },
                "NoReplyMention": {
                    "enabled": false
                },
                "NoScreensharePreview": {
                    "enabled": false
                },
                "NoServerEmojis": {
                    "enabled": false
                },
                "NoSystemBadge": {
                    "enabled": false
                },
                "NoTypingAnimation": {
                    "enabled": false
                },
                "NoUnblockToJump": {
                    "enabled": true
                },
                "NormalizeMessageLinks": {
                    "enabled": false
                },
                "NotificationVolume": {
                    "enabled": true,
                    "notificationVolume": 13.380281690140844
                },
                "NSFWGateBypass": {
                    "enabled": true
                },
                "OnePingPerDM": {
                    "enabled": true,
                    "channelToAffect": "group_dm",
                    "allowMentions": true,
                    "allowEveryone": true
                },
                "oneko": {
                    "enabled": false
                },
                "OpenInApp": {
                    "enabled": false
                },
                "OverrideForumDefaults": {
                    "enabled": false
                },
                "PartyMode": {
                    "enabled": false
                },
                "PauseInvitesForever": {
                    "enabled": false
                },
                "PermissionFreeWill": {
                    "enabled": false
                },
                "PermissionsViewer": {
                    "enabled": false,
                    "permissionsSortOrder": 0,
                    "defaultPermissionsDropdownState": false
                },
                "petpet": {
                    "enabled": false
                },
                "PictureInPicture": {
                    "enabled": false
                },
                "PinDMs": {
                    "enabled": false,
                    "pinOrder": 0,
                    "dmSectioncollapsed": false
                },
                "PlainFolderIcon": {
                    "enabled": true
                },
                "PlatformIndicators": {
                    "enabled": true,
                    "list": false,
                    "badges": false,
                    "messages": false,
                    "colorMobileIndicator": true
                },
                "PreviewMessage": {
                    "enabled": false
                },
                "PronounDB": {
                    "enabled": false
                },
                "QuickMention": {
                    "enabled": false
                },
                "QuickReply": {
                    "enabled": true,
                    "shouldMention": 0
                },
                "ReactErrorDecoder": {
                    "enabled": false
                },
                "ReadAllNotificationsButton": {
                    "enabled": false
                },
                "RelationshipNotifier": {
                    "enabled": true,
                    "notices": false,
                    "offlineRemovals": true,
                    "friends": true,
                    "friendRequestCancels": true,
                    "servers": true,
                    "groups": true
                },
                "ReplaceGoogleSearch": {
                    "enabled": false
                },
                "ReplyTimestamp": {
                    "enabled": true
                },
                "RevealAllSpoilers": {
                    "enabled": true
                },
                "ReverseImageSearch": {
                    "enabled": false
                },
                "ReviewDB": {
                    "enabled": true,
                    "notifyReviews": true,
                    "showWarning": true,
                    "hideTimestamps": false,
                    "hideBlockedUsers": true
                },
                "RoleColorEverywhere": {
                    "enabled": true,
                    "chatMentions": true,
                    "memberList": true,
                    "voiceUsers": true,
                    "reactorsList": true,
                    "colorChatMessages": false,
                    "messageSaturation": 30
                },
                "SecretRingToneEnabler": {
                    "enabled": false
                },
                "Summaries": {
                    "enabled": false
                },
                "SendTimestamps": {
                    "enabled": true,
                    "replaceMessageContents": true
                },
                "ServerInfo": {
                    "enabled": true
                },
                "ServerListIndicators": {
                    "enabled": false,
                    "mode": 2
                },
                "ShikiCodeblocks": {
                    "enabled": false,
                    "theme": "https://raw.githubusercontent.com/shikijs/shiki/0b28ad8ccfbf2615f2d9d38ea8255416b8ac3043/packages/shiki/themes/dark-plus.json",
                    "tryHljs": "SECONDARY",
                    "useDevIcon": "GREYSCALE",
                    "bgOpacity": 100
                },
                "ShowAllMessageButtons": {
                    "enabled": true
                },
                "ShowConnections": {
                    "enabled": false,
                    "iconSize": 32,
                    "iconSpacing": 1
                },
                "ShowHiddenChannels": {
                    "enabled": true,
                    "hideUnreads": true,
                    "showMode": 0,
                    "defaultAllowedUsersAndRolesDropdownState": true
                },
                "ShowHiddenThings": {
                    "enabled": true,
                    "showTimeouts": true,
                    "showInvitesPaused": true,
                    "showModView": true,
                    "disableDiscoveryFilters": true,
                    "disableDisallowedDiscoveryFilters": true
                },
                "ShowMeYourName": {
                    "enabled": false
                },
                "ShowTimeoutDuration": {
                    "enabled": true,
                    "displayStyle": "ssalggnikool"
                },
                "SilentMessageToggle": {
                    "enabled": false
                },
                "SilentTyping": {
                    "enabled": true,
                    "showIcon": false,
                    "contextMenu": true,
                    "isEnabled": true
                },
                "SortFriendRequests": {
                    "enabled": true,
                    "showDates": true
                },
                "SpotifyControls": {
                    "enabled": false
                },
                "SpotifyCrack": {
                    "enabled": false
                },
                "SpotifyShareCommands": {
                    "enabled": false
                },
                "StartupTimings": {
                    "enabled": false
                },
                "StickerPaste": {
                    "enabled": false
                },
                "StreamerModeOnStream": {
                    "enabled": false
                },
                "SuperReactionTweaks": {
                    "enabled": true,
                    "superReactByDefault": false,
                    "unlimitedSuperReactionPlaying": false,
                    "superReactionPlayingLimit": 0
                },
                "TextReplace": {
                    "enabled": true
                },
                "ThemeAttributes": {
                    "enabled": true
                },
                "Translate": {
                    "enabled": true,
                    "showChatBarButton": true,
                    "service": "google",
                    "deeplApiKey": "",
                    "autoTranslate": false,
                    "showAutoTranslateTooltip": true
                },
                "TypingIndicator": {
                    "enabled": true,
                    "includeCurrentChannel": true,
                    "includeMutedChannels": false,
                    "includeBlockedUsers": true,
                    "indicatorMode": 3
                },
                "TypingTweaks": {
                    "enabled": true,
                    "showAvatars": true,
                    "showRoleColors": true,
                    "alternativeFormatting": true
                },
                "Unindent": {
                    "enabled": true
                },
                "UnlockedAvatarZoom": {
                    "enabled": false
                },
                "UnsuppressEmbeds": {
                    "enabled": true
                },
                "UserVoiceShow": {
                    "enabled": true,
                    "showInUserProfileModal": true,
                    "showInMemberList": true,
                    "showInMessages": true
                },
                "USRBG": {
                    "enabled": true,
                    "nitroFirst": true,
                    "voiceBackground": true
                },
                "ValidReply": {
                    "enabled": true
                },
                "ValidUser": {
                    "enabled": true
                },
                "VoiceChatDoubleClick": {
                    "enabled": true
                },
                "VcNarrator": {
                    "enabled": false
                },
                "VencordToolbox": {
                    "enabled": true
                },
                "ViewIcons": {
                    "enabled": true
                },
                "ViewRaw": {
                    "enabled": false
                },
                "VoiceDownload": {
                    "enabled": true
                },
                "VoiceMessages": {
                    "enabled": true
                },
                "VolumeBooster": {
                    "enabled": false
                },
                "WhoReacted": {
                    "enabled": true
                },
                "XSOverlay": {
                    "enabled": false
                },
                "YoutubeAdblock": {
                    "enabled": true
                },
                "NoTrack": {
                    "enabled": true,
                    "disableAnalytics": true
                },
                "Settings": {
                    "enabled": true,
                    "settingsLocation": "aboveNitro"
                },
                "SupportHelper": {
                    "enabled": true
                }
            },
            "notifications": {
                "timeout": 5000,
                "position": "bottom-right",
                "useNative": "not-focused",
                "logLimit": 50
            },
            "cloud": {
                "authenticated": false,
                "url": "https://api.vencord.dev/",
                "settingsSync": false,
                "settingsSyncVersion": 1729059455140
            }
        }
      '';
    };
  };
}
