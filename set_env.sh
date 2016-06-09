#!/bin/bash

# export variables to shell by sourcing script . ./set_env.sh $1 $2

export CSPACE_CONVERTER_TYPE=${1:-PastPerfect}
export CSPACE_CONVERTER_PROFILE=${2:-ppsobjectsdata}
export CSPACE_CONVERTER_DOMAIN=${3:-core.collectionspace.org}
