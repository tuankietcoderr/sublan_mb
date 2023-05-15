#!bin/sh

flutter build apk --release

cp build/app/outputs/apk/release/app-release.apk apk/app.apk

