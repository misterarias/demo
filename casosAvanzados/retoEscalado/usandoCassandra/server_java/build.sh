#!/bin/sh

mvn package && docker build -t reto3server .
