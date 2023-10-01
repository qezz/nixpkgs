list:
	nix-env --show-trace -f ${PWD} -qaP '*' | cat

%:
	nix-build --show-trace ${PWD} -A $@
