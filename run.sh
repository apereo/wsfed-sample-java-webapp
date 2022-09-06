#!/bin/sh

export SP_SSL_KEYSTORE_PASSWORD=$SP_SSL_KEYSTORE_PASSWORD
export SP_SSL_KEYSTORE_PATH=$SP_SSL_KEYSTORE_PATH
echo "Running Docker container with keystore ${SP_SSL_KEYSTORE_PATH} with password ${SP_SSL_KEYSTORE_PASSWORD}"
exec ./gradlew build appStart -x test --no-daemon \
  -Dsp.sslKeystorePath=$SP_SSL_KEYSTORE_PATH \
  -Dsp.sslKeystorePassword=$SP_SSL_KEYSTORE_PASSWORD