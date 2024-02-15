# Step 1: Build the Next.js app in a Node.js environment
FROM node:alpine as builder

ARG CONTENTFUL_SPACE_ID
ARG CONTENTFUL_ACCESS_TOKEN
ARG CONTENTFUL_ENVIRONMENT
ARG CONTENTFUL_PREVIEW_ACCESS_TOKEN
ARG CONTENTFUL_PREVIEW_SECRET

ENV CONTENTFUL_SPACE_ID=${CONTENTFUL_SPACE_ID}
ENV CONTENTFUL_ACCESS_TOKEN=${CONTENTFUL_ACCESS_TOKEN}
ENV CONTENTFUL_ENVIRONMENT=${CONTENTFUL_ENVIRONMENT}
ENV CONTENTFUL_PREVIEW_ACCESS_TOKEN=${CONTENTFUL_PREVIEW_ACCESS_TOKEN}
ENV CONTENTFUL_PREVIEW_SECRET=${CONTENTFUL_PREVIEW_SECRET}

# Set the working directory in the Docker container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock) to the Docker environment
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of your Next.js app's source code to the Docker environment
COPY . .

# Build your Next.js application
RUN npm run build

# Step 2: Serve the Next.js app using a Node.js server
FROM node:alpine

# Set the working directory in the Docker container
WORKDIR /app

# Copy the built Next.js app and necessary files from the builder stage
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose the port your app runs on
EXPOSE 3000

# Command to run your app
CMD ["npm", "start"]
