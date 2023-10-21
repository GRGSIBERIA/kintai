#!/bin/sh

for file in ./seeder/*
do
    cobc -x -F ${file} -o ./bin/seeder/$(basename ${file} .cob)
done

for file in ./src/*
do
    cobc -x -F ${file} -o ./bin/$(basename ${file} .cob)
done