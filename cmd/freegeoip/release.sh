#!/bin/bash

VERSION=$(go run main.go -version | cut -d\  -f2)

function pack() {
	dir=freegeoip-v$VERSION-$1
	mkdir $dir
	cp -r ${binary} public $dir
	sync
	tar -czf ${dir}.tar.gz $dir
	sha256sum ${dir}.tar.gz | cut -f 1 -d " " > ${dir}.tar.gz.sha256
	rm -rf $dir
}

for OS in linux darwin freebsd windows
do
	binary=freegeoip
	[ $OS = "windows" ] && binary=${binary}.exe
	GOOS=$OS GOARCH=amd64 go build -o ${binary} -ldflags '-w -s'
	sleep 1
	pack $OS-amd64
	rm -f ${binary}
done
