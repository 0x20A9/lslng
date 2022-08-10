#!/bin/sh


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
		printf "$lang ─ $version\n"
	else # no it's not
		printf ""
	fi

}


get_lang "python" "python --version | grep -E -o '[0-9]+\.[0-9]+\.[0-9]+'"
get_lang "lua" "lua -v | grep -E -o -m 1 '[0-9]+\.[0-9]+\.[0-9]+'| head -n 1"
get_lang "go" "go env GOVERSION | sed -e 's/^go//' -e 's/$/.0/'"
get_lang "java" "java -version 2>&1 | head -n 1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+'"
#get_lang "perl" "perl -e 'print substr($^V, 1)' >/dev/null 2>&1"
get_lang "ruby" "ruby --version | grep -E -o -m 1 '[0-9]+\.[0-9]+\.[0-9]+'| head -n 1"
get_lang "php" "php -v | grep -E -o -m 1 '[0-9]+\.[0-9]+\.[0-9]+'| head -n 1"





