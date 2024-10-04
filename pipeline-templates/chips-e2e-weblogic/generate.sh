#!/bin/bash

# Change to the directory where this script is located
cd "$(dirname "$0")"

# Source the local copy of a bash implementation of the Moustache templating library
# Originally downloaded from https://raw.githubusercontent.com/tests-always-included/mo/refs/tags/3.0.5/mo
. ../lib/mo

# Identify an alphabetical list of profiles by looking under
# groups/multi-weblogic-infrastructure/profiles/heritage-development-eu-west-2
PROFILES=$( ls -1 ../../groups/multi-weblogic-infrastructure/profiles/heritage-development-eu-west-2 )

# Create an array of the profiles and export for the mo function to use
export ENVIRONMENTS=( ${PROFILES} )

# Pipe the template through the mo function
cat chips-e2e-weblogic.template | mo  