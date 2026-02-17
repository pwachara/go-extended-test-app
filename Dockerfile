# -------- Stage 1: Build SvelteKit Frontend --------
FROM node:20-alpine AS frontend

WORKDIR /ui

# Copy package files and install dependencies
# Note: If your frontend is in a subfolder (e.g. /ui), adjust paths: COPY ui/package*.json ./
COPY package*.json ./
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the app (outputs to /ui/build by default with adapter-static)
RUN npm run build


# -------- Stage 2: Build Go Backend --------
FROM golang:1.25-alpine AS backend

WORKDIR /app

# Copy Go module files
COPY go.mod go.sum ./
RUN go mod download

# Copy the Go source code
COPY . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app


# -------- Stage 3: Final Runtime Image --------
FROM alpine:latest

WORKDIR /app

# 1. Copy the Go binary from the backend stage
COPY --from=backend /app/app .

# 2. Copy the built SvelteKit files into pb_public
# We take the "build" folder from the 'frontend' stage and place it at './pb_public'
COPY --from=frontend /ui/build ./pb_public

# Create persistence directory
RUN mkdir -p /app/pb_data
VOLUME /app/pb_data

EXPOSE 8090

CMD ["./app", "serve", "--dir=/app/pb_data", "--http=0.0.0.0:8090"]
