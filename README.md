
# Overviewer #

## Setup ##

This project is a pipeline for downloading Minecraft files, rendering those
files with the
[Overviewer project](https://github.com/overviewer/Minecraft-Overviewer/),
then serving them over HTTP with [Caddy](https://caddyserver.com/) on port 8080
on the host.

### Docker and Compose ###

You will first need to install Docker and Compose on your server.

### Minecraft Server ###

Assuming your Multicraft server only gives you FTP access, you will need to set
your FTP username, password, host, and directory to download from:

```python
MC_FTP_USER=multicraft-username
MC_FTP_PASS=multicraft-password
MC_FTP_HOST=minecraft-host.tld
MC_FTP_DIR=My World Name
```

Add these lines to `minecraft/.env`.


### Overviewer ###

First you will need to get your Google Maps API key from
[https://developers.google.com/maps/documentation/javascript/get-api-key](https://developers.google.com/maps/documentation/javascript/get-api-key).

Then you will need to specify your Minecraft version and your Google Maps API key in
`overviewer/.env`:

```python
MC_VERSION=1.11.2
GOOGLE_MAPS_API_KEY=...
```

Next, you will need to create your own Overviewer config file
`overviewer/overviewer_config.py`. See 
[Overviewer configuration documentation](http://docs.overviewer.org/en/latest/config/)
for configuration options.

Here is an example configuration:

```python

worlds["My World Name"] = "/mnt/minecraft"

renders['overworld'] = {
    'world': "My World Name",  # Refers to the world name in Minecraft
    'title': "My World Name",  # The name to show in the map browser
    'dimension': 'overworld',
    # 'rendermode': smooth_lighting,  # looks good, but slow
}

renders['netherworld'] = {
    'world': "My World Name",
    'title': "My Netherworld Name",
    'dimension': 'nether',
    'rendermode': nether_smooth_lighting,  # have to specify rendermode
}

renders['end'] = {
    'world': "My World Name",
    'title': "End of My World Name",
    'dimension': 'end',
    # Turn down strength of shadows so it's lighter
    'rendermode': [Base(), EdgeLines(), Lighting(strength=0.5)]
}

customwebassets = "/config/assets"

outputdir = "/mnt/map"
```


### Host Port ###

By default, this project serves map files over HTTP on port 8080. To serve it
over port 80, change the host port in `docker-compose.yml`:

```diff
   caddy:
     image: zzrot/alpine-caddy
     depends_on:
       - overviewer
     ports:
-      - "8080:80"
+      - "80:80"
```


## Running ##

### Initial Run ###

Once you are done configuring the pipeline, you should be able to run the
project with a simple `docker-compose up`.

On the first run, your entire Minecraft map will be downloaded and rendered
from scratch. This may take a very long time. Wait for the `overviewer`
container to finish rendering before testing the website.

### Subsequent Runs ###

After the map is downloaded, the `wget` command will only download and update
files that have changed, and Overviewer will only re-render chunks that have
changed. For this reason, it is recommended to run `docker-compose` in the
foreground the first time. After that, you can start the pipeline up in a
detached state with `docker-compose up -d`.


## TODO ##

* Make it easier to adjust host port
* Make it easier to customize `minecraft` container
