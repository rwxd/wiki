# Ruff

## Pre-Commit Ruff Hooks on NixOS

Running a `ruff` pre-commit hook on NixOS will not work, because the installed ruff binary from the pypi package
does not work under NixOS.

```bash
ruff.....................................................................Failed
- hook id: ruff
- exit code: 127

Could not start dynamically linked executable: /home/$USER/.cache/pre-commit/repolrdyg6v2/py_env-python3.11/bin/ruff
NixOS cannot run dynamically linked executables intended for generic
linux environments out of the box. For more information, see:
https://nix.dev/permalink/stub-ld

ruff-format..............................................................Failed
- hook id: ruff-format
- exit code: 127

Could not start dynamically linked executable: /home/$USER/.cache/pre-commit/repolrdyg6v2/py_env-python3.11/bin/ruff
NixOS cannot run dynamically linked executables intended for generic
linux environments out of the box. For more information, see:
https://nix.dev/permalink/stub-ld
```

A workaround is removing the downloaded binary and symlinking the installed ruff through nixpkgs.

```bash
PYPI_RUFF="<path to pypi binary>"; rm "$PYPI_RUFF" && ln -s $(which ruff) "$PYPI_RUFF"

# Example
PYPI_RUFF="/home/$USER/.cache/pre-commit/repolrdyg6v2/py_env-python3.11/bin/ruff"; rm "$PYPI_RUFF" && ln -s $(which ruff) "$PYPI_RUFF"
```

**Links**

- <https://github.com/astral-sh/ruff-pre-commit/issues/22>
