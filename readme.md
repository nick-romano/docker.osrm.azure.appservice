# docker.osrm.azure.appservice

## Summary

- This repo builds a docker image for the project OSRM backend service that can be run within an Azure App Service container system. It is a cost effective and easy to manage system for running OSRM.

## How to use

- Make sure docker is installed and running.
- find an osm.pbf file that you want to use for your backend
- the build takes two build arguments, OSM_FILE and DOWNLOAD_URL
- run
  - `docker build . --build-arg OSM_FILE=berlin-latest.osm.pbf --build-arg DOWNLOAD_URL=https://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf -t osrm.berlin:latest`
- push the image to docker hub, or azure container repository
- configure azure app service to use a linux container, and set the container url to the image you just pushed
- in the App Service "Configuration" Tab, make sure to set an "Application Setting" variable of `WEBSITES_PORT` to `3000`

## Why?

- Azure App service is great for this because its relatively cheap, and assigns you a web url that you can use for requests. that way you don't worry about ssl certs, etc.
- BUT Azure app service has a limit for url length, and since OSRM backend loves to use massive URLS to communicate, we need a way to send that url data through a POST request 
   - OSRM doesn't allow POST requests
- SO, this container has a small node.js server in front of OSRM to allow POST requests to the OSRM server. just insert a body into the post with the params specified in `body.params`
  - for example 
  - ```fetch("https://osrmrouter.azurewebsite.net/match/v1/car/", {method: "POST", data: {params: "13.388860,52.517037?number=3&bearings=0,20?number=3&bearings=0,20"}})```
