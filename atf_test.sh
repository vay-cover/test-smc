#!/bin/bash

function rand(){
  min=$1
  max=$(($2-$min+1))
  num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
  echo $(($num%$max+$min))
}

function dec2hex(){
    printf "0x%x" $1
}


function all_32()
{
    local smc_invoke_path=$1
    x1=0
    x2=0
    x3=0
    x4=0

    #输入超大数据
    for (( function_id=0x83000000 ; function_id<=0x8300FFFF ; function_id+=1))
    do
        x1=$(rand 10000000000000000 10000000000000000000)
        x2=$(rand 10000000000000000 10000000000000000000)
        x3=$(rand 10000000000000000 10000000000000000000)
        x4=$(rand 10000000000000000 10000000000000000000)
        echo "$function_id $x1 $x2 $x3 $x4" > $smc_invoke_path
    done 

    #输入参数为0或1
    for (( function_id=0x83000000 ; function_id<=0x8300FFFF ; function_id+=1))
    do
        x1=$(rand 0 1)
        x2=$(rand 0 1)
        x3=$(rand 0 1)
        x4=$(rand 0 1)
        echo "$function_id $x1 $x2 $x3 $x4" > $smc_invoke_path
    done 

}

function all_64()
{
    local smc_invoke_path=$1
    x1=0
    x2=0
    x3=0
    x4=0

    #输入超大数据
    for (( function_id=0xC3000000 ; function_id<=0xC300FFFF ; function_id+=1))
    do
        x1=$(rand 10000000000000000 10000000000000000000)
        x2=$(rand 10000000000000000 10000000000000000000)
        x3=$(rand 10000000000000000 10000000000000000000)
        x4=$(rand 10000000000000000 10000000000000000000)
        echo "$function_id $x1 $x2 $x3 $x4" > $smc_invoke_path
    done 

    #输入参数为0或1
    for (( function_id=0xC3000000 ; function_id<=0xC300FFFF ; function_id+=1))
    do
        x1=$(rand 0 1)
        x2=$(rand 0 1)
        x3=$(rand 0 1)
        x4=$(rand 0 1)
        echo "$function_id $x1 $x2 $x3 $x4" > $smc_invoke_path
    done 

}

function stress()
{
    local times=$1
    local smc_invoke_path=$2

    for (( i=1 ; i<=$times ; i+=1))
    do
        echo -e '\033[32m This is the '$i' test begin-------------------- \033[0m'
        all_32 $smc_invoke_path
        all_64 $smc_invoke_path
        echo -e '\033[32m This is the '$i' test Pass--------------------- \033[0m'
    done

    echo -e '\033[32m Test End!! \033[0m'

}


 
func=$1
shift
$func $@
exit $?