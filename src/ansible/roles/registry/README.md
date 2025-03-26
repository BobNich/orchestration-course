## Registry role

This Ansible role sets up and deploys a Docker registry using Docker Compose.

## Features
- Creates necessary directories for the registry setup
- Configures persistent storage for registry data
- Deploys the registry as a Docker container
- Configures networking and routing with Traefik

## Requirements
- Docker and Docker Compose installed on the target machine
- Traefik as a reverse proxy

## Role Variables

| Variable              | Description                                      | Default              |
|-----------------------|--------------------------------------------------|----------------------|
| `stacks_directory`    | Base directory for stack deployments             | `/home/vagrant`      |
| `service_stack_name`  | Name of the service stack                        | `registry`           |
| `public_network_name` | Name of the public Docker network                | `public_network`     |
| `service_image`       | Docker image for registry                        | `registry:2`         |
| `service_name`        | Name of the registry service                     | `registry`           |
| `service_port`        | Internal registry port                           | `5000`               |
| `service_volume_name` | Name of the Docker volume for registry storage   | `registry_volume`    |
| `service_volume_path` | Path to store registry data inside the container | `/data`              |
| `service_http_route`  | Route for the registry service                   | `registry.localhost` |
| `localhost_domain`    | Domain used for local services                   | `localhost`          |

## Configuration Files
- `docker-compose.yml`: Defines the registry service, volumes, and network settings

## Deployment Steps
1. Ensure Docker and Docker Compose are installed.
2. Include the role in your playbook:

```yaml
- hosts: registry_servers
  roles:
    - role: registry
```

## Verification
- Check if the registry service is running:
  ```sh
  docker ps | grep <service_name>
  ```
- Verify registry accessibility:
  ```sh
  curl http://<service_http_route>/v2/_catalog
  ```

## Notes
- Ensure firewall rules allow traffic on the defined ports
- Modify `traefik.yml` to enable authentication for the registry
- Persistent storage is used to retain images across restarts

## License
MIT

## Author
Bob Nicholson, Yawl
