#! /bin/sh
# Usage: <this script> <arg_host>
set -u


if [ $# -ne 1 ]; then
    echo '[Error] Illegal arguments'
    echo "    Usage: $0 <cql> <yarg_host>"
    exit -1
fi

arg_hosts="$1"

format_host() {
    if [ $1 = $arg_hosts ] ; then
        host=$arg_hosts
    else 
        num_formated=$(printf "%0${2}d" $1)
        host=`echo $arg_hosts|sed -r "s/\[[0-9,\-]+\]/$num_formated/gi"`
    fi
    echo $host 
}

host_numbers_str=`echo $arg_hosts|sed -r "s/^.+[0-9]*\[(([0-9,])+|([0-9]+-[0-9]+))\].+$/\1/"`
if [ $host_numbers_str = $arg_hosts ] && [ `echo $host_numbers_str|egrep "\[|\]"` ] ; then 
    echo '[Error] Illegal arguments. format of <arg_host.'
    exit 1
fi

first_num=`echo $host_numbers_str|sed -r "s/^([0-9]+)[0-9,-]+/\1/"`
digit=${#first_num}


if [ `echo $host_numbers_str | grep '-'` ] ; then   
	seq_arg=`echo $host_numbers_str|sed -r "s/^([0-9]+)-([0-9]+)$/\1 \2/"`
    for num in `seq $seq_arg`; do
        echo `format_host $num $digit`
    done    
elif [ `echo $host_numbers_str | grep ','` ] ; then
    host_num=`echo "$host_numbers_str" | sed -e 's/,/ /g'`
    for num in $host_num; do
        host=`echo $arg_hosts|sed -r "s/\[[0-9,\-]+\]/$num/gi"`
        echo `format_host $num $digit`
    done
else 
    echo `format_host $arg_hosts $digit`
fi

