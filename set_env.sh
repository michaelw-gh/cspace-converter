#!/bin/bash

# . ./set_env.sh bonsai.collectionspace.org
export CSPACE_CONVERTER_DOMAIN=${1:-core.collectionspace.org}
export DISABLE_SPRING=1