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

#RUN adduser -D appuser
#USER appuser

COPY --from=builder /app/app .

EXPOSE 8090

CMD ["./app", "serve", "--http=0.0.0.0:8090"]
