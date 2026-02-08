FROM node:20-alpine as build-deps
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install dependencies without running prepare scripts
RUN echo "Iniciando install..." && \
    npm ci --ignore-scripts && \
    echo "Install concluído."

# Copy source code
COPY src/ ./src/
COPY tsconfig.json ./
COPY tsconfig.app.json ./
COPY tsconfig.node.json ./
COPY vite.config.ts ./
COPY postcss.config.js ./
COPY tailwind.config.js ./
COPY index.html ./
COPY components.json ./
COPY public/ ./public/

# Add ARGs for build time
ARG VITE_EVOLUTION_API_URL
ARG VITE_EVOLUTION_API_KEY
ARG VITE_APP_NAME
ENV VITE_EVOLUTION_API_URL=$VITE_EVOLUTION_API_URL
ENV VITE_EVOLUTION_API_KEY=$VITE_EVOLUTION_API_KEY
ENV VITE_APP_NAME=$VITE_APP_NAME

# Build the application
RUN echo "Iniciando build..." && \
    npm run build && \
    echo "Build concluído."

FROM nginx:alpine

ENV PUBLIC_HTML=/usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf

COPY .docker/nginx.conf /etc/nginx/conf.d/

COPY .docker/start.sh /

COPY --from=build-deps /usr/src/app/dist ${PUBLIC_HTML}

EXPOSE 80

ENTRYPOINT [ "/bin/sh", "/start.sh" ]
