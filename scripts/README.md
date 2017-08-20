# db-setup
Production database proviosionning with master-slave replication based on [sameersbn/docker-postgresql](https://github.com/sameersbn/docker-postgresql).

Data is persisted to `/var/db` (on the host)

## Running the cluster:

1. On exoscale, create a host (Ubuntu 16.04 LTS) for the master and at least one for the slave. Make sure they share the same security group allowing connections to the port `5432`. The master DB also needs to accept connections on port `5432` from the application server.

2. Get the content of this repo onto the two servers

3. On the master, run `./run-master.sh`
4. On the slave(s) you must pass the master's IP address in the environment, e.g. `REPLICATION_HOST=159.100.241.16 ./run-slave.sh`

## Monitoring

* Is the node running? `docker ps`
* Logs: `docker logs postgresql`
* Stop and destroy the container: `docker stop postgresql && docker rm postgresql` (data is persisted)
* Connect to db: `docker exec -it postgresql sudo -u postgres psql -d kiwi`
