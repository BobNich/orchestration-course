# Proxy Role

This Ansible role sets up and deploys a reverse proxy using Traefik with Docker Compose.

## Features
- Creates necessary directories for the proxy setup
- Copies configuration templates
- Deploys Traefik as a Docker container
- Configures networking and routing
- Supports automatic service discovery with Traefik labels

## Requirements
- Docker and Docker Compose installed on the target machine

## Role Variables

| Variable              | Description                          | Default           |
|-----------------------|--------------------------------------|-------------------|
| `stacks_directory`    | Base directory for stack deployments | `/home/vagrant`   |
| `service_stack_name`  | Name of the service stack            | `proxy`           |
| `public_network_name` | Name of the public Docker network    | `public_network`  |
| `service_image`       | Docker image for Traefik             | `traefik:latest`  |
| `service_name`        | Name of the Traefik service          | `proxy`           |
| `service_port`        | Internal service port                | `8080`            |
| `http_port`           | External HTTP port                   | `80`              |
| `https_port`          | External HTTPS port                  | `443`             |
| `service_http_route`  | Route for the proxy service          | `proxy.localhost` |
| `localhost_domain`    | Domain used for local services       | `localhost`       |

## Configuration Files
- `docker-compose.yml`: Defines the Traefik service and network
- `traefik.yml`: Configures Traefik settings such as API dashboard, entry points, and providers

## Deployment Steps
1. Ensure Docker and Docker Compose are installed
2. Include the role in your playbook:

```yaml
- hosts: proxy_server
  roles:
    - role: proxy
```

## Verification
- Check if the proxy service is running:
  ```sh
  docker ps | grep <service_name>
  ```
- Access the Traefik dashboard:
  ```
  http://<service_http_route>
  ```
- Validate routing by checking the configured service routes.

## Notes
- Ensure firewall rules allow traffic on the defined ports
- Modify `traefik.yml` for production environments to disable insecure dashboard access
- For HTTPS, configure TLS certificates in Traefik

## License
MIT

## Author
Bob Nicholson, Yawl

