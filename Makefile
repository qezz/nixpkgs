list:
	export NIXPKGS=${PWD}
	nix-env -f ${NIXPKGS} -qaP '*' | cat
