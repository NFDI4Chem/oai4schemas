#!/usr/bin/env bash

## Exit on any error
set -e

## Setup the OAI provider

if /bin/false ; then
./createFormats.sh http://10.22.13.12:6081/oai-backend
./createCrosswalks.sh http://10.22.13.12:6081/oai-backend
./createSets.sh http://10.22.13.12:6081/oai-backend
fi

## Import Data

if /bin/false ; then
./massbank-jsonld2oai.sh "https://github.com/MassBank/MassBank-data/releases/latest/download/MassBank.json"
fi

./chemotion-jsonld2oai.sh "https://github.com/elixir-europe/biohackathon-projects-2023/raw/main/7/dumps/chemotion-datadump


