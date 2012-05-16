#!/bin/bash

rm -rf ./dump/*
./webapp.pl dump
git add *
git ci -m "$*"
git push
cd dump
git add *
git ci -m "$*"
git push
