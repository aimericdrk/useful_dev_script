#!/bin/bash

# A simple test runner for the tests defined in ftest.toml
# It reads the test definitions, runs the commands, and compares the output and exit codes.
# Made by aimericdrk on github : https://github.com/aimericdrk/useful_dev_script/tree/main/tests
# To use it, just put your tests in ftest.toml and run this script.
# in the makefile you can add a rule like this :
#
# test:ftests:
# 	chmod +x ./tests/tester.sh
# 	./tests/tester.sh
#
# to write new tests follow the following format :
# [[test]]
# name = "test n°1"  // here you can put any name you want
# command = "./problem_two < tests/test_sample_one.txt" // here you put the command (use \n for new line and \t for tab) to run your program with the argument or input files
# expected.stdout = '4\n2'  // here you put the expected output of your program, use \n for new line and \t for tab
# expected.stderr = "" // here you put the expected stderr of your program, use \n for new line and \t for tab, if you want to ignore stderr put --skip
# expected.exit_code = 0 // here you put the expected exit code of your program
# [[test]]

FILE=tests/ftest.toml
COUNT=0
TOTAL=0
LIST_ERROR="\n"
# Read in the file and split into sections
while IFS= read -r line; do
  if [[ "$line" == "[[test]]" ]]; then
    read -r -d '' test << "EOF"
EOF
    test="$(sed -n '/^\[\[test\]\]/q;p')"
    # Parse the name, command, and expected output/exit code
    name=$(echo "$test" | grep -oP '(?<=name = ")[^"]*')
    cmd=$(echo "$test" | grep -oP '(?<=command = ")[^"]*')
    expected_stdout=$(echo "$test" | grep -oP "(?<=expected\.stdout = ')[^']*")
    expected_stderr=$(echo "$test" | grep -oP '(?<=expected\.stderr = ")[^"]*')
    expected_exit_code=$(echo "$test" | grep -oP '(?<=expected\.exit_code = )[^"]*')
    # Run the command and compare output and exit code
    echo -n "Running test $name : "
    output=$($cmd 2>&1)
    exit_code=$?
    expected_stdout=$(echo -e "$expected_stdout" | tr '\n' '\n')
    TOTAL=$((TOTAL + 1))
    if [[ $expected_stdout = "--skip" ]]; then
      expected_stdout=$(echo "$output")
    fi
    if [[ "$output" == "$expected_stdout" && $exit_code -eq $expected_exit_code ]]; then
      echo -e "\n\033[0;32m passed\033[0m"
      COUNT=$((COUNT + 1))
      #echo -e "echo "::file=tests/tester.sh,title=$name passed : ::$cmd""
    else
      echo -e "\n\033[0;31m Failed\033[0m"
      if [[ "$output" != "$expected_stdout" ]]; then
        #echo -e "echo "::error file=tests/tester.sh,title=$name failed output are not the same: ::expected stdout: $expected_stdout actual stdout: $output""
        echo -E "expected stdout:"
        echo -E "$expected_stdout"
        echo -E "actual stdout:"
        echo -E "$output"
      fi
      if [[ $exit_code -ne $expected_exit_code ]]; then
        #echo -e "echo "::error file=tests/tester.sh,title=$name failed exit code are not the same: ::expected exit code: $expected_exit_code actual exit code : $exit_code""
        echo "expected exit code: $expected_exit_code"
        echo "actual exit code: $exit_code"
      fi
      LIST_ERROR="$LIST_ERROR\n$name"
    fi
  fi
done < "$FILE"


if [[ $COUNT = $TOTAL ]]; then
  echo -e "\n\033[0;32m $COUNT/$TOTAL tests passed\033[0m"
else
  echo -e "\n\033[0;31m $COUNT/$TOTAL tests passed\033[0m"
  echo -e "\033[0;31m Failed tests: $LIST_ERROR\n\033[0m"
fi
