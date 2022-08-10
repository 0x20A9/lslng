#!/bin/sh


# grabbers for compilers
# includes: 
# gcc g++ clang

# -------------------------------------
get_gcc() {
	local v=""
	if command -v gcc >/dev/null 2>&1; 
	then
		v=$(gcc -dumpversion)
		echo $v
	else
		echo ""
	fi
}

get_gplusplus() {
	local v=""
	if command -v g++ >/dev/null 2>&1; 
	then
		v=$(g++ -dumpversion)
		echo $v
	else
		echo ""
	fi
}

get_clang() {
	local v=""
	if command -v clang >/dev/null 2>&1; 
	then
		v=$(clang -dumpversion)
		echo $v
	else
		echo ""
	fi
}

get_rustc() {
	local v=""
	if command -v rustc >/dev/null 2>&1; 
	then
		v=$(rustc -Vv | tail -n+2 | grep release | awk '{print $2}') 
		echo $v
	else
		echo ""
	fi
}

get_javac() {
	local v=""
	if command -v javac >/dev/null 2>&1; 
	then
		v=$(javac -version | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+')
		echo $v
	else
		echo ""
	fi
}


# -------------------------------------

printf "\n\n\n"



branch() {
	lang="$1"
	lst="$2"
	printf "${lang}\n"
	#printf "─ ${lang}\n"
	
	for name in $lst
	#for name in "${arr[@]:1}"
	do
		# format command
		command="get_${name}"
		command=${command//"++"/"plusplus"} # cant name func w/ ++
		
		version=$($command)
		
		if [[ $version ]];
		then # yes it's found
			printf "  └─ $name ─ $version\n"
		else # no it's not
			printf ""
		fi

	done
#printf "\n"
}

branch "C" "clang gcc"
branch "C++" "g++"
branch "rust" "rustc"
branch "java" "javac"



printf "\n\n\n"


