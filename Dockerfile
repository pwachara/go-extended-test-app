# -------- Build stage --------
FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app

# -------- Runtime stage --------
FROM alpine:latest

WORKDIR /app

# copy binary
COPY --from=builder /app/app .

# copy pb_public from repo (if exists)
COPY --from=builder /app/pb_public ./pb_public

# create persistent directory for PocketBase data
RUN mkdir -p /app/pb_data

EXPOSE 8090

CMD ["./app", "serve", "--http=0.0.0.0:8090"]
