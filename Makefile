.PHONY: update clean

update:
	home-manager switch --flake .#filipe

clean:
	nix-collect-garbage -d
