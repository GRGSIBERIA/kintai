#!/bin/sh

for file in ./seeder/*
do
    cobc -x -F ${file} -o ./bin/seeder/$(basename ${file})
    ./bin/seeder/$(basename ${file})
done