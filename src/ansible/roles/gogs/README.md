## Gogs Role

This Ansible role sets up and deploys a Gogs Git service using Docker Compose, ensuring a lightweight and efficient self-hosted Git solution.

## Features
- Configures PostgreSQL as the database backend
- Deploys Gogs
- Sets up SSH and HTTP access
- Defines network allowlist for local services

## Requirements
- Docker and Docker Compose installed on the target machine
- Traefik as a reverse proxy
- `community.docker` collection

## Role Variables

| Variable                       | Description                          | Default                     |
|--------------------------------|--------------------------------------|-----------------------------|
| `stacks_directory`             | Base directory for stack deployments | `/home/vagrant`             |
| `public_network_name`          | Name of the public Docker network    | `public_network`            |
| `internal_network_name`        | Name of the internal Gogs network    | `gogs_internal_network`     |
| `service_name`                 | Name of the Gogs service             | `git`                       |
| `service_image`                | Docker image for Gogs                | `gogs/gogs`                 |
| `service_web_port`             | HTTP Port for web access             | `3000`                      |
| `service_ssh_port`             | SSH Port for external access         | `10022`                     |
| `service_volume_name`          | Name of the volume for Gogs data     | `git_volume`                |
| `service_volume_path`          | Path inside the container for data   | `/data`                     |
| `service_database_name`        | Name of the database service         | `postgres`                  |
| `service_database_image`       | Docker image for PostgreSQL          | `postgres:17`               |
| `service_database_volume_name` | Volume name for PostgreSQL           | `postgres_volume`           |
| `service_database_volume_path` | Path inside the database container   | `/var/lib/postgresql/data`  |
| `database_user`                | Database username                    | `<vault_postgres_user>`     |
| `database_password`            | Database password                    | `<vault_postgres_password>` |
| `database_name`                | Name of the database                 | `<vault_postgres_db>`       |
| `service_http_route`           | HTTP route for accessing Gogs        | `git.localhost`             |
| `local_network_allowlist`      | Local network allowlist for services | `jenkins.localhost`         |

## Configuration Files
- `docker-compose.yml`: Defines the Gogs and PostgreSQL services

### Security Configuration
In the `app.ini` file, the following must be added under the `[security]` section:

```ini
[security]
LOCAL_NETWORK_ALLOWLIST = <local_network_allowlist>
```

This setting ensures that Gogs can interact with local services such as Jenkins for webhooks and integrations.

## Deployment Steps
1. Ensure Docker and Docker Compose are installed
2. Include the role in your playbook:

```yaml
- hosts: gogs_servers
  roles:
    - role: gogs
```

3. Update the `app.ini` configuration file inside the container (located at `/data/gogs/conf/`) to include the required security settings

## Verification
- Check if the Gogs container is running:
  ```sh
  docker ps | grep <service_name>
  ```
- Access the Gogs UI:
  ```
  http://<service_http_route>
  ```
- Verify SSH access:
  ```sh
  ssh -p <service_ssh_port> git@git.localhost
  ```
- Ensure local services (e.g., Jenkins) can communicate with Gogs through the network allowlist

## Notes
Installation configuration:

### Database Settings

* Database Type: ```postgres```
* Host: ```postgres```
* User: ```<database_user>```
* Password: ```<database_password>```
* Database Name: ```<database_name>```
* Schema: ```public```
* SSL Mode: ```Disable```

### Application General Settings

* Application Name: ```<your_organization>```
* Repository Root Path: ```/data/git/gogs-repositories```
* Run User: ```git```
* Domain: ```<service_http_route>```
* SSH Port: ```22```, do not use Builtin SSH Server
* HTTP Port: ```3000```
* Application URL: ```http://<service_http_route>/```
* Log Path: ```/app/gogs/log```
* Default Branch: ```main```

## License
MIT

## Author
Bob Nicholson, Yawl
