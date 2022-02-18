#!/bin/bash

curl https://keybase.io/codecovsecurity/pgp_keys.asc | gpg --no-default-keyring --keyring trustedkeys.gpg --import

curl -Os https://uploader.codecov.io/latest/linux/codecov

curl -Os https://uploader.codecov.io/latest/linux/codecov.SHA256SUM

curl -Os https://uploader.codecov.io/latest/linux/codecov.SHA256SUM.sig

gpgv codecov.SHA256SUM.sig codecov.SHA256SUM

shasum -a 256 -c codecov.SHA256SUM

chmod +x codecov

mix coveralls.json

./codecov -t ${CODECOV_TOKEN}