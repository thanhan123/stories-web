# Use an official Node.js image as the base
FROM node:18-alpine AS build

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Generate Prisma Client and build the app
RUN npx prisma generate
RUN npm run build

# Production stage
FROM node:18-alpine AS production

# Set working directory in the container
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/prisma ./prisma

# Environment variables (e.g., database connection details)
ENV PORT=3000
EXPOSE 3000

# Copy the entrypoint script
COPY ./entrypoint.sh ./
RUN chmod +x /app/entrypoint.sh

# Set the entrypoint to run the script
ENTRYPOINT ["/app/entrypoint.sh"]