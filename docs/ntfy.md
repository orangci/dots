## Ntfy usage

See the [documentation](https://ntfy.orangc.net/docs/publish).

When an access token is required, create one via web (https://ntfy.orangc.net/login > Account).

Minimal command: `curl -d "CONTENT" -u :NTFY_ACCESS_TOKEN https://ntfy.orangc.net/TOPIC`.

Use -H for headers. Example: `curl -d "CONTENT" -H "t: Title" -H "p: high" -u :ACCESS_TOKEN https://ntfy.orangc.net/TOPIC`.
The t is for the title and p is for priority. Possible priorities: max/urgent/5, high/4, default/unspecified/3, low/2, min/1.
You can use -H ta: TAG. Tags that can be converted to emojis will be, see https://ntfy.orangc.net/docs/emojis/.
Markdown formatting is supported for body content (-d).

You can time notifications.
`-H "At: tomorrow, 10am"`
`-H "In: 30min"`
`-H "Delay: 1639194738"`