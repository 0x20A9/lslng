#!/bin/sh


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

get_compiler_info() {
	inp="$1"
	set -- $inp

	if command -v $1 >/dev/null 2>&1; 
	then
		v=$(javac -version | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+')
		echo $v
	else
		echo ""
	fi
}

branch() {

	#start="└─"
	
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
			printf "   - $name ─ $version\n"
		else # no it's not
			printf ""
		fi

	done
#printf "\n"
}


compilers_main() {

	printf "compilers\n"

	branch "C" "clang gcc"
	branch "C++" "g++"
	branch "rust" "rustc"
	branch "java" "javac"


}


# -------------------------------------


get_v() {
	lang="$1"
	cmd="$2"
	if command -v $lang >/dev/null 2>&1; 
	then
		#printf "─ $lang"
		eval $cmd
	else
		printf ""
	fi
}

get_lang() {
	
	lang="$1"
	cmd="$2"
	
	version=$(get_v "$lang" "$cmd")
	
	if [[ $version ]];
	then # yes it's found
		printf "   - $lang ─ $version\n"
	else # no it's not
		printf ""
	fi

}


lang_main() {


	printf "langauges\n"

	get_lang "python" "python --version | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+'"
	get_lang "lua" "lua -v | grep -E -o -m 1 '[0-9]+\.[0-9]+\.[0-9]+'| head -n 1"
	get_lang "go" "go env GOVERSION | sed -e 's/^go//' -e 's/$/.0/'"
	get_lang "java" "java -version 2>&1 | head -n 1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+'"
	#get_lang "perl" "perl -e 'print substr($^V, 1)' >/dev/null 2>&1"
	get_lang "ruby" "ruby --version | grep -E -o -m 1 '[0-9]+\.[0-9]+\.[0-9]+'| head -n 1"
	get_lang "php" "php -v | grep -E -o -m 1 '[0-9]+\.[0-9]+\.[0-9]+'| head -n 1"



}

# -------------------------------------

printf "\n\n\n"

compilers_main
printf "\n"
lang_main

printf "\n\n\n"









