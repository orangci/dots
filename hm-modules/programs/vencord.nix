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
            "autoUpdate": false,
            "autoUpdateNotification": false,
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
            "winNativeTitleBar": true,
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
                "AlwaysAnimate": {
                    "enabled": false
                },
                "AlwaysTrust": {
                    "enabled": true,
                    "domain": true,
                    "file": true
                },
                "AnonymiseFileNames": {
                    "enabled": false
                },
                "AppleMusicRichPresence": {
                    "enabled": false
                },
                "AutomodContext": {
                    "enabled": true
                },
                "BANger": {
                    "enabled": false
                },
                "BetterFolders": {
                    "enabled": false
                },
                "BetterGifAltText": {
                    "enabled": false
                },
                "BetterGifPicker": {
                    "enabled": true
                },
                "BetterNotesBox": {
                    "enabled": false
                },
                "BetterRoleContext": {
                    "enabled": true
                },
                "BetterRoleDot": {
                    "enabled": false
                },
                "BetterSessions": {
                    "enabled": true,
                    "backgroundCheck": false
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
                    "enabled": false
                },
                "BlurNSFW": {
                    "enabled": false
                },
                "CallTimer": {
                    "enabled": true
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
                    "enabled": false
                },
                "ConsoleShortcuts": {
                    "enabled": false
                },
                "CopyEmojiMarkdown": {
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
                    "enabled": false
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
                    "enabled": false
                },
                "F8Break": {
                    "enabled": false
                },
                "FakeNitro": {
                    "enabled": true,
                    "enableEmojiBypass": false,
                    "enableStickerBypass": true,
                    "enableStreamQualityBypass": true,
                    "transformEmojis": true,
                    "transformStickers": true,
                    "transformCompoundSentence": false
                },
                "FakeProfileThemes": {
                    "enabled": false
                },
                "FavoriteEmojiFirst": {
                    "enabled": false
                },
                "FavoriteGifSearch": {
                    "enabled": true
                },
                "FixCodeblockGap": {
                    "enabled": false
                },
                "FixSpotifyEmbeds": {
                    "enabled": false
                },
                "FixYoutubeEmbeds": {
                    "enabled": true
                },
                "ForceOwnerCrown": {
                    "enabled": true
                },
                "FriendInvites": {
                    "enabled": false
                },
                "FriendsSince": {
                    "enabled": false
                },
                "GameActivityToggle": {
                    "enabled": true,
                    "oldIcon": false
                },
                "GifPaste": {
                    "enabled": true
                },
                "GreetStickerPicker": {
                    "enabled": false
                },
                "HideAttachments": {
                    "enabled": false
                },
                "iLoveSpam": {
                    "enabled": false
                },
                "IgnoreActivities": {
                    "enabled": false
                },
                "ImageLink": {
                    "enabled": false
                },
                "ImageZoom": {
                    "enabled": false
                },
                "ImplicitRelationships": {
                    "enabled": false,
                    "sortByAffinity": true
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
                    "enabled": false
                },
                "MaskedLinkPaste": {
                    "enabled": true
                },
                "MemberCount": {
                    "enabled": true,
                    "toolTip": true,
                    "memberList": true
                },
                "MentionAvatars": {
                    "enabled": true
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
                    "automodEmbeds": "never",
                    "listMode": "blacklist",
                    "idList": ""
                },
                "MessageLogger": {
                    "enabled": true,
                    "deleteStyle": "overlay",
                    "logDeletes": true,
                    "collapseDeleted": false,
                    "logEdits": false,
                    "inlineEdits": true,
                    "ignoreBots": false,
                    "ignoreSelf": false,
                    "ignoreUsers": "",
                    "ignoreChannels": "",
                    "ignoreGuilds": ""
                },
                "MessageTags": {
                    "enabled": false
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
                            "showInChat": false,
                            "showInNotChat": true
                        },
                        "OWNER": {
                            "text": "Owner",
                            "showInChat": false,
                            "showInNotChat": true
                        },
                        "ADMINISTRATOR": {
                            "text": "Admin",
                            "showInChat": false,
                            "showInNotChat": true
                        },
                        "MODERATOR_STAFF": {
                            "text": "Staff",
                            "showInChat": false,
                            "showInNotChat": true
                        },
                        "MODERATOR": {
                            "text": "Mod",
                            "showInChat": false,
                            "showInNotChat": true
                        },
                        "VOICE_MODERATOR": {
                            "text": "VC Mod",
                            "showInChat": false,
                            "showInNotChat": true
                        },
                        "CHAT_MODERATOR": {
                            "text": "Chat Mod",
                            "showInChat": false,
                            "showInNotChat": true
                        }
                    },
                    "dontShowForBots": true
                },
                "Moyai": {
                    "enabled": false
                },
                "MutualGroupDMs": {
                    "enabled": false
                },
                "NewGuildSettings": {
                    "enabled": true
                },
                "NoBlockedMessages": {
                    "enabled": false
                },
                "NoDefaultHangStatus": {
                    "enabled": true
                },
                "NoDevtoolsWarning": {
                    "enabled": true
                },
                "NoF1": {
                    "enabled": true
                },
                "NoMosaic": {
                    "enabled": false
                },
                "NoOnboardingDelay": {
                    "enabled": true
                },
                "NoPendingCount": {
                    "enabled": true,
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
                    "enabled": false
                },
                "NSFWGateBypass": {
                    "enabled": false
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
                    "enabled": false,
                    "spotify": true,
                    "steam": true,
                    "epic": true,
                    "tidal": true
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
                    "enabled": false
                },
                "petpet": {
                    "enabled": false
                },
                "PictureInPicture": {
                    "enabled": false
                },
                "PinDMs": {
                    "enabled": false
                },
                "PlainFolderIcon": {
                    "enabled": false
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
                    "enabled": false
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
                    "reactorsList": true
                },
                "SearchReply": {
                    "enabled": true
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
                    "theme": "https://raw.githubusercontent.com/millsp/material-candy/master/material-candy.json",
                    "tryHljs": "SECONDARY",
                    "useDevIcon": "COLOR",
                    "bgOpacity": 100
                },
                "ShowAllMessageButtons": {
                    "enabled": true
                },
                "ShowAllRoles": {
                    "enabled": true
                },
                "ShowConnections": {
                    "enabled": false
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
                    "enabled": true
                },
                "SilentMessageToggle": {
                    "enabled": false
                },
                "SilentTyping": {
                    "enabled": false
                },
                "SortFriendRequests": {
                    "enabled": false,
                    "showDates": false
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
                "StreamerModeOnStream": {
                    "enabled": false
                },
                "SuperReactionTweaks": {
                    "enabled": false
                },
                "TextReplace": {
                    "enabled": true
                },
                "ThemeAttributes": {
                    "enabled": true
                },
                "TimeBarAllActivities": {
                    "enabled": false
                },
                "Translate": {
                    "enabled": true,
                    "autoTranslate": false,
                    "showChatBarButton": true
                },
                "TypingIndicator": {
                    "enabled": true,
                    "includeMutedChannels": false,
                    "includeCurrentChannel": true
                },
                "TypingTweaks": {
                    "enabled": true,
                    "showAvatars": true,
                    "showRoleColors": true,
                    "alternativeFormatting": true
                },
                "Unindent": {
                    "enabled": false
                },
                "UnlockedAvatarZoom": {
                    "enabled": false
                },
                "UnsuppressEmbeds": {
                    "enabled": false
                },
                "UserVoiceShow": {
                    "enabled": false
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
                    "enabled": false
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
                    "enabled": false
                },
                "VoiceMessages": {
                    "enabled": true,
                    "noiseSuppression": true,
                    "echoCancellation": true
                },
                "VolumeBooster": {
                    "enabled": false
                },
                "WatchTogetherAdblock": {
                    "enabled": false
                },
                "WhoReacted": {
                    "enabled": true
                },
                "XSOverlay": {
                    "enabled": false
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
                "settingsSyncVersion": 1724416422188
            }
        }
      '';
    };
  };
}
