# docker.osrm.azure.appservice

## Summary

- This repo builds a docker image for the project OSRM backend service that can be run within an Azure App Service container system. It is a cost effective and easy to manage system for running OSRM.

## How to use

- Make sure docker is installed and running.
- Download a *.osm.pbf file from geofabrik.de, like
  - `wget http://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf`
- run
  - `docker build . --build-arg OSM_FILE=berlin-latest.osm.pbf -t osrm.berlin:latest`
- push the image to docker hub, or azure container repository
- configure azure app service to use a linux container, and set the container url to the image you just pushed

## Why?

- Azure App service is great for this because its relatively cheap, and assigns you a web url that you can use for requests. that way you don't worry about ssl certs, etc.
