#!/usr/bin/env bash

function assert {
    if [ $1 -eq $2 ]
    then
        yn=" no"
        if [ "$3" == "change" ]
        then
            status=1
            result=FAIL
        else
            result=PASS
        fi
    else
        yn=
        if [ "$3" == "change" ]
        then
            result=PASS
        else
            status=1
            result=FAIL
        fi
    fi
    echo "[$result]$yn rerun with $4"
}

cargo clean
rm -rf dir
mkdir dir
touch dir/foo

echo -n .
sleep 1
first_run=$(cargo run -q)

echo -n .
sleep 1
second_run=$(cargo run -q)

echo -n .
sleep 1
touch dir/foo
third_run=$(cargo run -q)

echo -n .
sleep 1
touch dir/bar
fourth_run=$(cargo run -q)

echo -n .
sleep 1
echo "quux" >>dir/foo
fifth_run=$(cargo run -q)

echo -n .
sleep 1
rm dir/bar
sixth_run=$(cargo run -q)

echo

status=0
assert $first_run  $second_run same   "no changes"
assert $second_run $third_run  change "changed timestamp"
assert $third_run  $fourth_run change "new file"
assert $fourth_run $fifth_run  change "changed file contents"
assert $fifth_run  $sixth_run  change "deleted file"

exit $status

