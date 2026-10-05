# NixOS Configuration

Mirror of my NixOS configuration.
This repository may not always reflect the latest version of the configuration.

## Structure

* `hosts/` — NixOS configuration for each machine
* `home/` — Home Manager user configuration
* `modules/` — reusable NixOS and Home Manager modules
* `dotfiles/` — user dotfiles
* `scripts/` — utility scripts
* `kubernetes/` — Kubernetes configuration
* `secrets/` — secrets managed with SOPS
* `docs/` — documentation
* `archives/` — archived configuration files
* `flake.nix` / `flake.lock` — Nix flake configuration and locked dependencies
* `Makefile` — common project commands

## Technologies

The configuration is built with:

* **NixOS**
* **Nix Flakes**
* **Home Manager**
* **sops-nix** for secrets management
* **Disko** for declarative disk configuration

## Machines

The flake currently defines three NixOS configurations:

* `laptop` — x86_64 Linux
* `desktop` — x86_64 Linux, using Disko
* `node-1` — Raspberry Pi 3B with 1 GB RAM, running aarch64 Linux. Builds are offloaded via SSH to a more powerful machine because the Raspberry Pi is too limited for local builds.

