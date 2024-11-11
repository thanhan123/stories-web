#!/bin/sh

# Run the Prisma migrations
npx prisma migrate deploy

# Start the NestJS application
exec node dist/main.js