#!/usr/bin/env sh

kubectl run admin-backend \
    --image=nginx \
    --labels app=admin-backend \
    --expose \
    --port 80

kubectl run admin-frontend \
    --image=nginx \
    --labels app=admin-frontend \
    --expose \
    --port 80

kubectl run frontend \
    --image=nginx \
    --labels app=frontend \
    --expose \
    --port 80

kubectl run backend \
    --image=nginx \
    --labels app=backend \
    --expose \
    --port 80
