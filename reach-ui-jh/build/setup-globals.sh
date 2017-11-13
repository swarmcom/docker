#!/bin/sh -e
cd reach-ui
sed -i "s|REF_UI|$COMMIT|" dist/config.js
