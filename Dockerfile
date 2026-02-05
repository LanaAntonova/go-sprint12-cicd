FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o parcel

FROM alpine:latest

RUN apk --no-cache add ca-certificates sqlite-libs

COPY --from=builder /app/parcel .

COPY tracker.db .

CMD ["./parcel"]