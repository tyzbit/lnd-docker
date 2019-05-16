# lnd-docker
My take on dockerizing LND.  

`latest` is manually triggered (daily at most frequent, but it may vary)
to build from `lnd` master, which means there might be unsquashed bugs. Use at
your own risk (I make every effort to provide stability and integrity)

I also create tags for every `lnd` tagged release from Sept 14, 2018 (v0.5-beta)
onward.

# How to use

Generally, you want to

- Mount a volume to `/root/.lnd`
- Specify a config file (inside the container) **OR**
- Use environment variables to control LND

## Simple Docker

Here's an example of getting started with Docker:

Create `lnd.conf` in a folder, then:

```
$ docker run -it --name lnd -v "$PWD":/root/ -e CONFIG_PATH=/root/lnd.conf lnd
```

This mounts the current directory to the container and specifies the config file.
The container will start and wait for an unlock.

```
$ docker exec -it lnd bash
$ lncli create
...
```

The critical files for `lnd` will be stored in that directory, which you can save
or make backups of if you wish.

## Using Environment Variables

If you want to use environment variables, just expose them to the container:

```
$ docker run -it --name lnd \
   -v "$PWD":/root/ \
   -e DEBUGLEVEL=info \
   -e BITCOIN_ACTIVE=true \
   -e BITCOIN_MAINNET=true \
   -e BITCOIN_NODE=bitcoind \
   -e BITCOIND_RPCHOST=192.168.1.2 \
   -e BITCOIND_RPCUSER=bitcoin \
   -e BITCOIND_RPCPASS=bitcoin \
   -e BITCOIND_ZMQPATH=tcp://192.168.1.2 \
   -e COLOR=#FF9900 \
   lnd
```

A full list of the environment variables you can use is [here](https://github.com/tyzbit/lnd-docker/blob/master/docker-entrypoint.sh#L9).

Please make a Pull Request if you happen to see one that's missing.

## UnRAID

Add the image with the following settings:

`Name: lnd`

`Image: tyzbit/lnd`

Then add the following path:

`/root/.lnd/`:`/mnt/user/appdata/lnd/`

Then add the following variable:

`CONFIG_PATH`:`/root/.lnd/lnd.conf`

If you do RPC stuff, expose those ports as well (usually 8080 and 10009)

Then click Apply, right click the new container and select Console, then run

```
$ lncli create
...
```

And follow the directions, saving your seed.

The critical files for `lnd` will be stored in `/mnt/user/appdata/lnd/`, which you can save
or make backups of if you wish.
