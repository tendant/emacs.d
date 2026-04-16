# emacs.d

Personal Emacs configuration.

## Quick Start

**1. Clone the repo**

```sh
git clone https://github.com/tendant/emacs.d.git ~/.emacs.d
```

**2. Create `~/.emacs.d/init.el`**

```elisp
(load "~/.emacs.d/my-init.el")
```

**3. Configure personal settings**

Copy and edit the following files with your own values:

- `load-path/my-mail-mu4e.el` — email accounts (mu4e)
- `load-path/my-mail-smtp-multi.el` — SMTP accounts
- `load-path/my-org-gcal.el` — Google Calendar OAuth credentials
- `load-path/my-erc.el` — IRC nickname

**4. Launch Emacs**

Packages are managed via `use-package` and will be installed automatically on first launch.

## Requirements

- Emacs 28+
- [mu](https://github.com/djcb/mu) (optional, for email)
