#!/bin/bash
set -ueo pipefail

# take a user positional argument 

ls -1a $1 | wc -l


#NUM=$(ls -1 $1 | wc -l)
#echo $NUM

