#!/bin/bash

javac UnsafeMemory.java ;
for i in {1..10}
do
    echo Unsynchronized; java UnsafeMemory Unsynchronized $1 $2 $3 $3 $3 $3 $4 $4 $4 $4 $5 $5 $5 $5 $6 $6 $6 $6 $7 $7 $7 $7 ;
    echo Synchronized; java UnsafeMemory Synchronized $1 $2 $3 $3 $3 $3 $4 $4 $4 $4 $5 $5 $5 $5 $6 $6 $6 $6 $7 $7 $7 $7 ;
    echo GetNSet; java UnsafeMemory GetNSet $1 $2 $3 $3 $3 $3 $4 $4 $4 $4 $5 $5 $5 $5 $6 $6 $6 $6 $7 $7 $7 $7 ;
    echo BetterSafe; java UnsafeMemory BetterSafe $1 $2 $3 $3 $3 $3 $4 $4 $4 $4 $5 $5 $5 $5 $6 $6 $6 $6 $7 $7 $7 $7 ;
    echo BetterSorry; java UnsafeMemory BetterSorry $1 $2 $3 $3 $3 $3 $4 $4 $4 $4 $5 $5 $5 $5 $6 $6 $6 $6 $7 $7 $7 $7 ;
done
