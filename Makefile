.PHONY: help switch update check fmt gc build-all

HOSTNAME := $(shell hostname) 
USERNAME := $(shell whoami)

KUBECONFIG := $(HOME)/.config/kube/node-1.yaml
KUBECTL := kubectl --kubeconfig $(KUBECONFIG)

flake-update:
	nix flake update

flake-metadata:
	nix flake metadata

flake-show:
	nix flake show

flake-lock:
	nix flake lock

flake-check:
	nix flake check --all-systems

system-switch:
	sudo nixos-rebuild switch --flake .#$(HOSTNAME)

system-test:
	sudo nixos-rebuild test --flake .#$(HOSTNAME)

system-generations:
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
	nix-env --list-generations

store-garbage:
	nix-env --delete-generations old
	sudo nix-collect-garbage -d

store-optimise:
	nix-store --optimise

home-switch:
	home-manager switch --flake .#$(USERNAME)

home-generations:
	home-manager generations

fmt:
	nix fmt

sops-encrypt-shared:
	@set -e; \
	TMP_KEY=$$(mktemp); \
	trap 'rm -f "$$TMP_KEY"' EXIT; \
	sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > "$$TMP_KEY"; \
	SOPS_AGE_KEY_FILE="$$TMP_KEY" sops -e -i secrets/hosts/shared.yaml

sops-decrypt-shared:
	@set -e; \
	TMP_KEY=$$(mktemp); \
	trap 'rm -f "$$TMP_KEY"' EXIT; \
	sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > "$$TMP_KEY"; \
	SOPS_AGE_KEY_FILE="$$TMP_KEY" sops -d -i secrets/hosts/shared.yaml

sops-encrypt-laptop:
	@set -e; \
	TMP_KEY=$$(mktemp); \
	trap 'rm -f "$$TMP_KEY"' EXIT; \
	sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > "$$TMP_KEY"; \
	SOPS_AGE_KEY_FILE="$$TMP_KEY" sops -e -i secrets/hosts/laptop.yaml

sops-decrypt-laptop:
	@set -e; \
	TMP_KEY=$$(mktemp); \
	trap 'rm -f "$$TMP_KEY"' EXIT; \
	sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > "$$TMP_KEY"; \
	SOPS_AGE_KEY_FILE="$$TMP_KEY" sops -d -i secrets/hosts/laptop.yaml


sops-encrypt-pihole:
	@set -e; \
	TMP_KEY=$$(mktemp); \
	trap 'rm -f "$$TMP_KEY"' EXIT; \
	sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > "$$TMP_KEY"; \
	SOPS_AGE_KEY_FILE="$$TMP_KEY" sops -e -i secrets/services/pihole.yaml

k8s-apply-pihole-secret:
	@set -e; \
	TMP_KEY=$$(mktemp); \
	trap 'rm -f "$$TMP_KEY"' EXIT; \
	sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > "$$TMP_KEY"; \
	SOPS_AGE_KEY_FILE="$$TMP_KEY" sops -d secrets/services/pihole.yaml | $(KUBECTL) apply -f -

k8s-apply-pihole:
	$(KUBECTL) apply -f kubernetes/pihole.yaml

k8s-restart-pihole:
	$(KUBECTL) rollout restart deployment/pihole -n pihole
	$(KUBECTL) rollout status deployment/pihole -n pihole

pihole: k8s-apply-pihole-secret k8s-apply-pihole