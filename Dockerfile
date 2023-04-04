FROM golang:latest

WORKDIR /app

COPY src .

EXPOSE 8000

ENTRYPOINT ["go", "run", "main.go"]