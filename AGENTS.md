# AGENTS.md

## This is a public repository

Everything committed here is publicly visible on GitHub. Nothing company-specific or machine-specific may be committed or pushed. That includes, but is not limited to:

- **Usernames and home paths.** No absolute paths containing a username (`/Users/<name>/…`, `/home/<name>/…`). Use `~` or `$HOME` instead.
- **Machine names.** No hostnames, computer names, or device identifiers.
- **Other repo names.** No names or paths of other repositories, work or personal, beyond this one.
- **Company information.** No employer or client names, internal URLs, hostnames, project names, account IDs, or work-specific aliases, functions, or tooling.
- **Credentials and identifiers.** No tokens, keys, cloud account or profile IDs, email addresses, or SSH host aliases.

When syncing a live config file back into this repo, diff it against the repo copy and carry over only the generic, portable lines. Leave anything matching the list above in the live file only. If a change can't be made portable, leave it out and tell the user, rather than committing it.

Before committing, check the staged diff for any of the above, e.g.:

```sh
git diff --cached | grep -nE '/Users/|/home/|@'
```

That check is a starting point, not a guarantee; read the diff too.
