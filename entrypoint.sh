#!/bin/sh
echo $SWAPI_PORT
exec lein ring server-headless $SWAPI_PORT