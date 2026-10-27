# Changelog

## 0.2.6

- `LINQ_ALLOW_FROM` hands the whole list of who may text the line in the environment, comma-separated, empty for
  nobody. Set, it is the one list: `access.json`'s `allowFrom` and `dmPolicy` and `LINQ_ALLOWED_SENDERS` are not read,
  the policy is `allowlist` and no pairing is offered, and the file is written without a list. A harness that keeps the
  list itself hands it this way, so nothing the session can write to its folder changes who gets through.

## 0.2.5

- `LINQ_CHANNEL_DIR` names the channel folder, `~/.claude/channels/linq` where it is unset: credentials, `access.json`,
  the poll state, the journal, `plugin.log` and `inbox/` all live there, and the skills read and write there. A harness
  gives each line's process its own, so several lines run on one machine user without sharing an access list or a
  poll cutoff. With it set there is no fallback to `~/.linq/config.json`: the CLI's profile is the machine user's last
  sign-in, and a process with a folder of its own is one line's.
- The server starts through `start.sh`, not `npm start`. It runs `npm install` and `tsc` only when `dist` is missing
  or older than `src` or `package.json`, then execs node. Every start used to install and compile, and on a loaded
  machine that ran past claude's 30-second MCP connect limit, so the channel never came up.

## 0.2.4

- Every text handed to claude is journaled to `~/.claude/channels/linq/inbound.jsonl`: its id, chat, sender and words,
  the claude session it went to (`CLAUDE_CODE_SESSION_ID`), and whether the hand-off threw. A harness reads it to tell
  a text claude never showed from one it did.
- A hand-off that throws is that text's: said, journaled with the error, and the poll goes on. It used to abort the
  poll before the save, and every text after it was marked seen and never sent.
- The state is saved after a failed poll too, with the cutoff unmoved, so its time says the poller is alive.
- stderr is kept in `~/.claude/channels/linq/plugin.log`. claude reads a server's stderr only at the handshake.
- The process exits when its stdin closes. Left behind by a killed claude, it polled on into a dead pipe.

## 0.2.3

- The startup greeting is once per recipient, not once per process: a number in the new `greeted` list in
  `access.json` is never greeted again, so a restart no longer texts the owner or costs a turn. `/linq:access greet`
  empties the list.
- `LINQ_CHANNEL_POLL=0` also silences the startup notification: a tools-only process receives nothing and speaks for
  no number, so it has nothing to announce.

## 0.2.0

- Restructured as installable Claude Code plugin (`/plugin install imessage@linq`)
- Added `/imessage:access` skill for access control (pairing, allowlist, policies)
- Added `/imessage:configure` skill for credential management
- Config stored in `~/.claude/channels/imessage/` (`.env` + `access.json`)
- Fixed react endpoint to match Linq SDK (`/reactions` not `/react`)
- Fixed reaction type `emphasize` (was `emphasis`)
- Webhook server handles EADDRINUSE gracefully
- Startup logic runs independently of webhook
- Legacy fallback for `~/.linq/config.json` with migration warning
- SMS/RCS fallback via `preferred_service` on all outbound messages
- 15 iMessage effects (confetti, fireworks, lasers, slam, gentle, etc.)
- Threaded replies via `reply_to` parameter
- File attachments on reply/send via Linq presigned URL upload
- Inbound photo download to `~/.claude/channels/imessage/inbox/`
- Migrated to `@linqapp/sdk` — no more raw API calls
- Text decorations (bold, italic, strikethrough, underline, shake, explode, etc.)
- Rich link previews via `send_link` tool
- Capability check (`check_capability`) for iMessage/RCS support
- `send` tool now returns `chat_id` and `message_id` for chaining

## 0.1.0

- Initial release
- Two-way iMessage bridge via Linq API
- Polling-based message retrieval (no ngrok needed)
- Reply, send, react, and edit_message tools
- Auto read receipts and typing indicators
- Contact card auto-setup
- Sender allowlist via environment variable
