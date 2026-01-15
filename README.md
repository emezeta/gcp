# GCP – Git · Commit · Patching

**GCP** is a Bash tool that helps you apply **"alien" patches** to a local Linux kernel using Git.

Whether you're working with a custom kernel fork, integrating patches from multiple sources, or managing hardware-specific modifications—GCP automates the tedious analysis and organization.

---

## Quick Start

You need three things:

1. **Source repository** – where the commits come from
2. **Destination repository** – your local kernel fork
3. **Pandora patch** – the patch you want to apply

### Example
```bash
gcp --origen /path/to/source/kernel \
    --destino /path/to/my/kernel \
    --patch /path/to/pandora.patch
```

GCP analyzes why Pandora fails, searches for related commits in the source, and generates a series of candidate patches (S1). You review and test them. If they resolve the issues, Pandora applies successfully. If not, GCP helps you analyze the new failures and extract another series (S2), repeating until convergence.

---

### How It Works
```
┌─────────────────────┐
│  Pandora.patch      │
│   (fails)           │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Analyze errors     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Search source repo  │
│ for related commits.│
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Generate S1         │
│ (candidate patches) │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Apply S1           │
│  to destination     │
└──────────┬──────────┘
           │
      ┌────┴────┐
      │         │
    Works?    Still fails?
      │         │ 
      ▼         ▼
   SUCCESS    Generate S2
              and repeat
              
```

---

## Features

- **Iterative patching** – Automates the series extraction and application
- **Auditable history** – Complete logs of what was attempted and why
- **Zero dependencies** – Just Bash and Git
- **Portable** – Works on Linux, macOS, WSL

---

## Requirements

- **Bash 4.0+**
- **Git**
- Both repositories should share a **common ancestor** (or be closely related)
- Source kernel should **compile** (at least the code you're interested in)

---

## Installation
```bash
git clone https://github.com/emezeta/gcp.git
cd gcp
chmod +x scripts/*.sh
```

### Configuration

Edit `scripts/gcp.conf` and set your repository paths:
```bash
export REPO_ORIGEN="/path/to/source/kernel"
export REPO_DESTINO="/path/to/destination/kernel"
export BRANCH_ORIGEN="source-branch"
export BRANCH_DESTINO="destination-branch"
```

Then initialize:
```bash
./scripts/00init.sh
```


---

## Documentation

Full documentation is in [`docs/`](./docs):

- [Quickstart Guide](./docs/quickstart.md)
- [How GCP Works](./docs/how-it-works.md)
- [Step-by-Step Workflow](./docs/workflow.md)
- [Troubleshooting](./docs/troubleshooting.md)
- [Limitations](./docs/limitations.md)

---

## Important Notes

- **GCP is not magic.** You'll review code, make decisions, and likely modify things manually.
- **Best results when:** Source and destination repos share a recent common ancestor.
- **Not suitable for:** Grafting patches between completely unrelated projects.
- **Current scope:** Tested on ARM architectures (Snapdragon X Elite on Dell Latitude 7455).
- **Feedback welcome** – Different architectures, different workflows, edge cases.

---

## Use Case

GCP was born from the need to integrate kernel patches from multiple independent repositories into a single device-specific branch. It's particularly useful for:

- **Custom hardware support** – Integrating vendor-specific drivers
- **Kernel forks** – Maintaining device-specific branches with upstream compatibility
- **Multi-source patching** – Consolidating fixes from different teams

---

## Status

Early development. Actively used on Dell Latitude 7455 with Snapdragon X Elite.

---

## Need Help?

- 📖 Read [Troubleshooting](./docs/troubleshooting.md)
- 🐛 Open an [issue](https://github.com/emezeta1/gcp/issues)
- 💬 Join the conversation: #aarch64-laptops on OFTC IRC

---

## Note

Development was assisted by **AI tools**.

---

## License

MIT License. See [`LICENSE`](./LICENSE) for details.
