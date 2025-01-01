# Use an official Node.js runtime as the base image
FROM node:alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker's caching mechanism
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --silent

# Copy the rest of the application source code
COPY . ./

# Expose the port your application runs on (default for React is 3000)
EXPOSE 3000

# Run the application
CMD ["npm", "start"]
