#!/bin/sh

# shebang


# --------------------------------------------------------------------
# version info search regex aided by https://stackoverflow.com/a/19854164
# --------------------------------------------------------------------



pprint() {
	Color_Off='\033[0m'       # Text Reset
	BYellow='\033[1;33m'      # Yellow
	BWhite='\033[1;37m'       # White
	White='\033[0;37m'        # White
	printf " $BYellow$1$Color_Off $White--$Color_Off $2\n"
	return

}

get_python() {
	
	count=0
	
	# normal pythons & alias python
	# compatible w/ Python 2.4-
		

	for item in "python" "python3" "python2"
	do
		
		if command -v $item >/dev/null 2>&1;
		then
			version=$( $item -c 'import sys; print(".".join([str(v) for v in sys.version_info[:3]]))' )
			pprint "$item" "$version"
			count=$((count + 1))
		fi
	done

	

	if (( $count == 0 )); then
		return
	fi

}

get_lua() {
	if ! command -v lua >/dev/null 2>&1;
	then
		return
	fi
	
	version=$(lua -v | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
	pprint "lua" "$version"
	
	for item in "luac" "luajit"
	do

		if command -v $item >/dev/null 2>&1;
		then
			version=$($item -v | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
			pprint "$item" "$version"
		fi
	done		
}

get_perl() {
	if ! command -v perl >/dev/null 2>&1;
	then
		return
	fi

	{ version=$(perl -e 'print substr($^V, 1)'); } 2>/dev/null; #https://unix.stackexchange.com/a/428508
	pprint "perl" "$version"
}


get_go() {
	if ! command -v go >/dev/null 2>&1;
	then
		return
	fi
	
	version=$(go env GOVERSION | sed -e 's/^go//')
	
	#if [ "$version" == "unknown" ]; 
	#then
	#	printf "" # TODO fix error; must use pkg info
	#fi	
	pprint "go" "$version"

	if command -v gccgo >/dev/null 2>&1;
	then
		version=$(gccgo --version | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+')
		pprint "gccgo" "$version"
	fi
	return
}

get_php() {
	if ! command -v php >/dev/null 2>&1;
	then
		return
	fi
	
	# aliased main
	version=$(php -v | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
	pprint "php" "$version"

	for major in {4..10}
	do
		for minor in {1..9}
		do
			p="php$major.$minor"
			if command -v "$p" >/dev/null 2>&1;
			then
				version=$("$p" -v | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
				pprint "$p" "$version"
			
			fi
		done

	done

	return
}

get_ruby() {
	#TODO there could be more versions
	if ! command -v ruby >/dev/null 2>&1;
	then
		return
	fi
	

	version=$(ruby --version | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
	pprint "ruby" "$version"
	
	# TODO; pkg manager gem; to add or not to add 
	
	for item in "rake"
	do	
		if command -v $item >/dev/null 2>&1;
		then
			version=$($item --version | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
			pprint "$item" "$version"
		fi
	done

	return

}


get_c() {
	count=0
	
	for item in "gcc" "g++" "make" "clang" "cmake" "gmake"
	do 
		if command -v $item >/dev/null 2>&1;
		then
			version=$($item --version | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)' | head -n 1)
			pprint "$item" "$version"
			count=$((count + 1))
		fi
	
	done

	return
}


get_rust() {
	for item in "rustc" "cargo"
	do
		if command -v $item >/dev/null 2>&1;
		then
			version=$($item --version | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)' | head -n 1)
			pprint "$item" "$version"
		fi
	done

	return
}

get_shells() {
	for item in "bash" "zsh" "fish"
	do
		if command -v $item >/dev/null 2>&1;
		then
			version=$($item --version | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
			pprint "$item" "$version"
		fi
	done


}



get_python	
get_lua
get_perl
get_go
get_php
get_ruby
get_c
get_rust

get_shells

