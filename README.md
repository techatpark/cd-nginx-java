# Contious Deployment with nginx and Spring Boot REST API
An Experimental POC to learn and optimize the process and techniques of Contious Deployment with nginx and Spring Boot REST API

# Steps
1. Start the Backup Server with current artifact
2. Shutdown Main Servers
3. Deploy New Artifacts to Main Servers one by one
4. Move the current artifcat to history
5. Shutdown Backup Server

# Notes
1. mv will fail if the file is in between copy
2. actuator should be available in Spring Boot
3. only /api/* should be exposed to outside world
