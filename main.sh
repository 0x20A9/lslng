#!/bin/sh

# --------------------------------------------------------------------
# version info search regex aided by https://stackoverflow.com/a/19854164
# --------------------------------------------------------------------


printtitle() {

	Color_Off='\033[0m'       # Text Reset
	BYellow='\033[1;33m'      # Yellow
	BWhite='\033[1;37m'       # White
	BGreen='\033[1;32m'       # Green
	
	tC="$BWhite"
	printf " $tC$1$Color_Off - |"
	return
}

pprint() {
	Color_Off='\033[0m'       # Text Reset
	Red='\033[0;31m'          # Red
	Green='\033[0;32m'        # Green
	Yellow='\033[0;33m'       # Yellow
	Blue='\033[0;34m'         # Blue
	Purple='\033[0;35m'       # Purple
	Cyan='\033[0;36m'         # Cyan
	White='\033[0;37m'        # White

	langC="$White"
	majorC="$Green"
	minor1C="$Cyan"
	minor2C="$Purple"
	
	
	printf " $langC$1$Color_Off "

	export IFS="."
	count=0
	for v in $2; do
		if [ $count = 0 ]; then
			c="$majorC"
		elif [ $count = 1 ]; then
			c="$minor1C"
		else [ $count = 2 ]
			c="$minor2C"
		fi
		
		
		if [ $count = 0 ]; then
			printf "$c$v$Color_Off"
		else
			printf "$White.$Color_Off$c$v$Color_Off"
		fi		

		count=$((count + 1))
	done

	if [ $count = 2 ]; then
		printf "$White.$Color_Off"$minor2C"0"$Color_Off""
	fi
	
	printf " |"

	return

}

get_python() {
	
	count=0
	
	# normal pythons & alias python
	# compatible w/ Python 2.4-

	for item in "python" "python3" "python2"; do
		if command -v $item >/dev/null 2>&1; then
			version=$( $item -c 'import sys; print(".".join([str(v) for v in sys.version_info[:3]]))' )
			if [ $count = 0 ]; then
				printtitle "python"
			fi

			pprint "$item" "$version"
			count=$((count + 1))
		fi
	done
	
	if (( $count == 0 )); then
		return
	fi
	
	printf "\n"
	return
}

get_lua() {
	if ! command -v lua >/dev/null 2>&1; then
		return
	fi
	
	version=$(lua -v | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
	
	printtitle "lua"
	pprint "lua" "$version"
	
	for item in "luac" "luajit"; do
		if command -v $item >/dev/null 2>&1; then
			version=$($item -v | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
			pprint "$item" "$version"
		fi
	done		
	
	printf "\n"
	return
}

get_perl() {
	if ! command -v perl >/dev/null 2>&1; then
		return
	fi
	
	printtitle "perl"
	{ version=$(perl -e 'print substr($^V, 1)'); } 2>/dev/null; #https://unix.stackexchange.com/a/428508
	pprint "perl" "$version"
	
	printf "\n"
	return

}


get_go() {
	if ! command -v go >/dev/null 2>&1; then
		return
	fi
	
	version=$(go env GOVERSION | sed -e 's/^go//')
	
	#if [ "$version" == "unknown" ]; 
	#then
	#	printf "" # TODO fix error; must use pkg info
	#fi	
	printtitle "go"
	pprint "go" "$version"

	if command -v gccgo >/dev/null 2>&1; then
		version=$(gccgo --version | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+')
		pprint "gccgo" "$version"
	fi
	
	printf "\n"
	return
}

get_php() {
	if ! command -v php >/dev/null 2>&1; then
		return
	fi
	
	# aliased main
	version=$(php -v | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
	
	printtitle "php"
	pprint "php" "$version"

	for major in {4..10}; do
		for minor in {1..9}; do
			p="php$major.$minor"
			if command -v "$p" >/dev/null 2>&1; then
				version=$("$p" -v | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
				pprint "$p" "$version"
			fi
		done
	done
	
	printf "\n"
	return
}

get_ruby() {
	#TODO there could be more versions
	if ! command -v ruby >/dev/null 2>&1; then
		return
	fi
	
	version=$(ruby --version | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
	printtitle "ruby"
	pprint "ruby" "$version"
	
	# TODO; pkg manager gem; to add or not to add 
	for item in "rake"; do
		if command -v $item >/dev/null 2>&1; then
			version=$($item --version | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
			pprint "$item" "$version"
		fi
	done

	printf "\n"
	return

}


get_c() {
	
	count=0
	for item in "gcc" "g++" "make" "clang" "cmake" "gmake"; do
		if command -v $item >/dev/null 2>&1; then
			version=$($item --version | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)' | head -n 1)
			
			if [ $count = 0 ]; then
				printtitle "c/c++"
			fi
			pprint "$item" "$version"
			count=$((count + 1))
		fi
	done
	
	if [ $count = 0 ]; then
		return
	fi
	
	printf "\n"
	return
}


get_rust() {

	count=0
	for item in "rustc" "cargo"; do
		if command -v $item >/dev/null 2>&1; then
			version=$($item --version | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)' | head -n 1)
			
			if [ $count = 0 ]; then
				printtitle "rust" 
			fi
			pprint "$item" "$version"
			count=$((count + 1))
		fi
	done
	
	if [ $count = 0 ]; then
		return
	fi
	
	printf "\n"
	return
}

get_shells() {

	count=0
	for item in "bash" "zsh" "fish"; do
		if command -v $item >/dev/null 2>&1; then
			version=$($item --version | grep -E -o -m 1 '([0-9]+([.][0-9]+)+)')
			
			if [ $count = 0 ]; then
				printtitle "shells" 
			fi
			pprint "$item" "$version"
			count=$((count + 1))
		fi
	done
	
	printf "\n"
	return
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

