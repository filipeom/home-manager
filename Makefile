.PHONY: update clean

update:
	home-manager switch --flake .#t14

clean:
	nix-collect-garbage -d
