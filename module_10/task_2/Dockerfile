# Base image
FROM node:14-alpine

# Create app directory
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY ./app/package*.json ./

ENV NODE_OPTIONS=--max_old_space_size=2048

# Install app dependencies
RUN npm ci

# RUN npm install -g @nestjs/schematicsgs

# Bundle app source
COPY ./app ./

# ENV NODE_ENV production

# Creates a "dist" folder with the production build
RUN npm run build

# Start the server using the production build
CMD [ "npm", "run", "start" ]