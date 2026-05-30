#!/bin/bash

echo "Checking Docker version..."
docker --version

echo "Checking Docker Compose version..."
docker compose version

echo "Running Docker test container..."
docker run hello-world
