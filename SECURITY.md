# Security Policy

## Supported versions

Security fixes are applied to the latest published Quorivell release on
[Google Play](https://play.google.com/store/apps/details?id=com.quorivell.app)
and to the `main` branch of this repository. Older builds may not receive
backports.

## Reporting a vulnerability

Please report security issues **privately**. Do not open a public GitHub issue
for vulnerabilities, especially anything involving data exposure, auth, sync,
or model/prompt handling.

Email **[support@quorivell.com](mailto:support@quorivell.com)** with subject
line `Security` and include:

- Quorivell / app version (or git commit if building from source)
- Platform (e.g. Android version, device class)
- Impact summary (what an attacker could do)
- Steps to reproduce (synthetic data only)
- Any suggested fix, if you have one

Do **not** attach real conversation text, credentials, payment details, or
private keys. Use synthetic or fully redacted samples.

We aim to acknowledge reports within a few business days and will coordinate
disclosure timing with you when a fix is ready.

## Scope notes

Quorivell is local-first. Source conversations and evidence are intended to
stay on device unless a user opts into an explicit remote flow. Reports that
violate that boundary (unexpected network exfiltration, insecure local stores,
broken consent gates) are especially valued.

Model weights (GGUF downloads) are third-party artifacts; report upstream
license or weight issues to their publishers when they are not specific to
this app’s packaging or download path.
