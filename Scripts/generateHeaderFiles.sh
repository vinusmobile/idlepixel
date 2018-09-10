#!/bin/bash

# Generate Header Collections
# Author: Trystan Pfluger
# Date: 2 Oct, 2012
# Copyright 2012 - Use as you wish with Attribution ;).

# Function parameter usage:
# $1 directory to search
# $2 file to collect generated header files

author="Trystan Pfluger"
today="$(date +%d/%m/%Y)"
thisYear="$(date +%Y)"
customStart="/*--START CUSTOM--*/"
customEnd="/*--END CUSTOM--*/"
nl="
"

function checkFileChanges
{
	found=0
	custom=0
	customContent="${customStart}"
	while read line
	do
		if [ "$line" == "$customStart" ] ; then
			found=1
			custom=1
		elif [ "$line" == "$customEnd" ]; then
			custom=0
		elif [ "$custom" == "1" ]; then
			customContent="${customContent}${nl}${line}"
		fi
	done < "${2}"

	if [ "$found" == "1" ]; then
		content="${1}${nl}${nl}${customContent}${nl}${customEnd}"
	else
		content="${1}"
	fi
	contentCount=$(echo "$content" | wc -l)
	newHeader=$(generateFileHeader "${3}")
	headerCount=$(echo "$newHeader" | wc -l)
	existingContent=$(tail -n $contentCount ${2})
	existingContentCount=$(cat ${2} | wc -l)
	contentCount=$[contentCount+headerCount]
	filename=$(basename $2)
	if [ "$content" != "$existingContent"  ] || [ "$contentCount" -ne "$existingContentCount" ] ; then
		content="${newHeader}${nl}${content}"
		echo "$filename has changed - re-generating."
		echo "${content}" > ${2}
	else 
		echo "No changes in $filename."
	fi
}

function generateFileHeader
{
	echo "//
//  $1
//
//  WARNING: DO NOT MODIFY, CHANGES WILL BE OVERWRITTEN.
//
//  Last generated on ${today}.
//  Copyright (c) ${thisYear} ${author}. All rights reserved.
//
" 
}

for d in "$1"/*
do
	if [[ -d $d ]] ; then
	  	directory="${d##*/}"
		headerFile="${d}Headers.h"
		importDump=""
		count=1
		for f in "$d"/*.h
		do
			count=$[count+1]
			file="${f##*/}"
			importDump="${importDump}${nl}#import \"$file\""
		done
		newContent="${importDump}"
		checkFileChanges "${newContent}" "${headerFile}" "${directory}Headers.h"
	fi
done

if [ "$2" != "" ] ; then
	headerFile="${2##*/}"

	importDump=""
	count=1

	for f in "$1"/*.h
	do
		file="${f##*/}"
		if [[ $headerFile != $file ]] ; then
			count=$[count+1]
			importDump="${importDump}${nl}#import \"$file\""
		fi
	done
	newContent="${importDump}"
	checkFileChanges "${newContent}" "${2}" "${headerFile}"
fi
