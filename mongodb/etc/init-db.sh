#!/bin/sh -e
mongoimport --db imdb --collection entity --drop --file /tmp/imdb.json
