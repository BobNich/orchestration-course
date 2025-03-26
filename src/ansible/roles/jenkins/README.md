## Jenkins role

This Ansible role sets up and deploys a Jenkins environment using Docker Compose, including a Jenkins controller and agent.

## Features
- Creates necessary directories for Jenkins and SSH configuration
- Deploys Jenkins controller and agent containers
- Configures networking and volume storage
- Secures SSH communication between controller and agent

## Requirements
- Docker and Docker Compose installed on the target machine
- Traefik as a reverse proxy
- `community.docker` and `community.crypto` collections

## Role Variables

| Variable                  | Description                                | Default                     |
|---------------------------|--------------------------------------------|-----------------------------|
| `stacks_directory`        | Base directory for stack deployments       | `/home/vagrant`             |
| `service_stack_name`      | Name of the service stack                  | `jenkins`                   |
| `public_network_name`     | Name of the public Docker network          | `public_network`            |
| `internal_network_name`   | Name of the internal Jenkins network       | `jenkins_internal_network`  |
| `controller_image`        | Docker image for Jenkins controller        | `jenkins/jenkins:lts-jdk17` |
| `controller_name`         | Name of the Jenkins controller service     | `jenkins-controller`        |
| `controller_public_port`  | Public HTTP port for Jenkins UI            | `8080`                      |
| `controller_volume_name`  | Name of the volume for Jenkins controller  | `jenkins_volume`            |
| `controller_volume_path`  | Path inside the container for Jenkins data | `/var/jenkins_home`         |
| `agent_image`             | Docker image for Jenkins agent             | `jenkins/ssh-agent`         |
| `agent_name`              | Name of the Jenkins agent service          | `jenkins-agent`             |
| `agent_volume_name`       | Name of the volume for Jenkins agent       | `jenkins_agent_volume`      |
| `agent_volume_path`       | Path inside the container for agent data   | `/home/jenkins/agent`       |
| `agent_target_ssh_dir`    | Path inside the agent for SSH keys         | `/home/jenkins/.ssh`        |
| `service_http_route`      | Route for accessing Jenkins                | `jenkins.localhost`         |
| `localhost_domain`        | Domain used for local services             | `localhost`                 |

## Configuration Files
- `docker-compose.yml`: Defines the Jenkins controller and agent services
- `ssh.yml`: Configures SSH for agent authentication
- `deploy.yml`: Handles the deployment process

## Deployment Steps
1. Ensure Docker and Docker Compose are installed
2. Include the role in your playbook:

```yaml
- hosts: jenkins_servers
  roles:
    - role: jenkins
```

## Verification
- Check if the Jenkins controller and agent are running:
  ```sh
  docker ps | grep <controller_name>
  docker ps | grep <agent_name>
  ```
- Access the Jenkins UI:
  ```
  http://<service_http_route>
  ```
- Verify agent connectivity in the Jenkins UI under `Manage Jenkins` > `Nodes`
- Connect the agent in the Jenkins web interface and add the private SSH key from `agent_target_ssh_dir` to Jenkins

## Notes
- Modify `traefik.yml` to configure authentication and security settings
- SSH keys are generated and configured for secure agent communication
- The agent must be connected in the Jenkins web interface, and the private SSH key from `agent_target_ssh_dir` must be added to Jenkins

## License
MIT

## Author
Bob Nicholson, Yawl

