#!/bin/sh

for file in ./seeder/*
do
    cobc -x -F ${file} -o ./bin/seeder/$(basename ${file} .cob)
    ./bin/seeder/$(basename ${file} .cob)
done