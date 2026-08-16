# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

1. **Do NOT open a public issue**
2. Open a [GitHub Security Advisory](https://github.com/tomkd555/skill-forge-win/security/advisories/new) on this repo
3. Or contact the maintainer directly

## Supported Versions

Only the latest version receives security updates.

## Security Practices

- No credentials or API keys are stored in this repository
- `install.ps1` writes only under `%USERPROFILE%\.claude\`
- The Python scripts use the standard library only, so no third-party package is installed
