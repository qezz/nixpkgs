list:
	nix-env -f ${PWD} -qaP '*' | cat

%:
	nix-build --show-trace ${PWD} -A $@
