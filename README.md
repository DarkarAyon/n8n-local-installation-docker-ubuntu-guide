# n8n-local-installation-docker-ubuntu-guide
A beginner-friendly guide and scripts for installing  n8n on Ubuntu with Docker Compose
Comprehensive Guide: Installing n8n on Ubuntu with Docker Compose

1. Introduction to n8n
n8n is a powerful, open-source workflow automation platform designed to be highly accessible, even for individuals who are not coding experts. It allows users to automate complex tasks and tests through an intuitive, node-based interface. This guide details the process of deploying n8n on an Ubuntu server using Docker. This deployment method is the industry standard for DevOps professionals, providing a fast, manageable, and flexible environment for scaling your automation infrastructure.

3. System Prerequisites
Before beginning the installation, ensure your Ubuntu system meets the following software requirements. These versions are verified for compatibility with this deployment workflow:

      docker --version
  Docker: Version 28 or higher.

  
    docker compose version
  Docker Compose: Version 2.35 or higher.
If Docker is not yet installed on your system, please refer to official installation documentation or a standard Docker setup guide  or Docker installation Guide before proceeding.


5. Server Preparation: Network Configuration
Proper network configuration is critical for reliable remote access to your n8n instance.
Identify IP Address: Determine the current IP address of your Ubuntu server using ip addr show.
Static IP Recommendation: It is strongly recommended to configure a static IP address for your server. Using a static IP ensures consistent access and prevents connectivity breaks if the server’s IP changes following a system reboot.

6. Data Persistence and Directory Structure
To ensure your workflows, settings, and encryption keys are not lost during container restarts or system migrations, you must implement a persistent file structure on the host machine.
Execute the following command to create the necessary directory hierarchy:
mkdir -p n8n-server/n8n-data
The n8n-data subfolder will serve as the persistent volume where all n8n configurations and user data are stored.

7. Permission Configuration
Docker containers often run services under specific non-root user IDs. For n8n to function correctly, the host directory must be writable by the container's internal user (typically UID 1000).
Execute this command to set the correct ownership:
sudo chown -R 1000:1000 n8n-server/n8n-data
Failure to set these permissions will result in "Permission Denied" errors when the container attempts to write to the database or save configurations.

8. Environment Configuration (.env)
The .env file centralizes configuration and secures sensitive credentials. Navigate to your n8n-server folder and create the file:
nano .env
Paste the following template, replacing the placeholder values with your specific details:
# Security: This password is used to encrypt your credentials in the database
N8N_ENCRYPTION_PASSWORD=your_strong_encryption_key
# Administration setup
N8N_USER_NAME=admin_user
N8N_PASSWORD=secure_password
# Network Settings
WEBHOOK_URL=http://your_server_ip:5678/
SERVER_IP_ADDRESS=your_server_ip
N8N_PORT=5678
Senior DevOps Security Note: After saving the file, restrict its permissions to ensure only the owner can read it, as it contains sensitive passwords:
chmod 600 .env
7. Deployment Configuration (docker-compose.yml)
The docker-compose.yml file acts as the orchestration blueprint. Create this file in the n8n-server directory:
nano docker-compose.yml
Paste the following configuration, which utilizes the variables defined in your .env file:
version: '3.8'

services:
  n8n:
    image: docker.n8n.io/n8nio/n8n
    container_name: n8n-server
    restart: always
    ports:
      - "${N8N_PORT}:5678"
    environment:
      - N8N_ENCRYPTION_PASSWORD=${N8N_ENCRYPTION_PASSWORD}
      - N8N_USER_NAME=${N8N_USER_NAME}
      - N8N_PASSWORD=${N8N_PASSWORD}
      - WEBHOOK_URL=${WEBHOOK_URL}
    volumes:
      - ./n8n-data:/home/node/.n8n

8. Service Deployment and Verification
With the configurations in place, you are ready to launch the service.
Ensure you are inside the n8n-server folder.
Start n8n in detached mode:
Heads Up: The initial startup may take several minutes as Docker downloads the n8n images and initializes the local environment.
Verification: Confirm the container is running successfully with the following command:
Look for a container with the name n8n-server and a status of "Up".

9. Managing the Service: Stopping n8n
If you need to update configurations or stop the service for maintenance, use the following command:
docker compose down
This command stops and removes the container instance. However, your data is safe; because we configured a persistent volume in Section 4, all workflows and credentials remain intact in the n8n-data folder.

10. Firewall Configuration (UFW)
n8n listens on port 5678 by default. If your Ubuntu server has the Uncomplicated Firewall (UFW) enabled, you must explicitly allow traffic to this port.
Execute the following:
sudo ufw allow 5678
If UFW is disabled, you may skip this step.

11. Initial Access and Admin Account Setup
Once the service is active, you can access the web interface to complete the setup.
Open a web browser and navigate to: http://[Your-Server-IP]:5678
On your first visit, n8n will prompt you to create the primary administrative account.
Enter the required details:
Username
Password
Email Address
