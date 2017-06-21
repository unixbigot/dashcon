# Continuous Dashboarding example

## Using the docker-compose file

**ELK and Node-RED**:

```
docker-compose build
docker-compose --build -d up
open http://localhost:1800/ & open http://localhost:5601/
```

**ELK only**:

```
docker-compose --build up -d elk
open http://localhost:5601/
```

**Node-RED only**:

```
docker-compose --build up -d red
open http://localhost:1800/
```

## Working with ELK

Pass your logfiles to localhost:5044 (filebeat) or localhost:5959 raw
(tcp/udp)



## Working with Node-RED

Visit http://localhost:1800/ for the flow editor, and
http://localhost:1800/ui for the dashboard.

Your flow configuration is written to red/flows.json

Build a prettification image (once only) with `docker build -f red/Dockerfile-pretty -t pretty red`

Prettify your flows.json for code-review with `docker run -it --rm -v $PWD/red:/data pretty`


