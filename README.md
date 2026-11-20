# Gym App Backend

Backend for a gym logging app, built with FastAPI.

## Requirements

- [uv](https://docs.astral.sh/uv/)
- Python 3.14 (uv downloads it if it isn't installed)
- [Docker](https://docs.docker.com/get-docker/) with the Compose and Buildx plugins, to run the app in containers. Docker Desktop includes both; on Linux they can be separate packages, such as `docker-compose` and `docker-buildx`.

## Setup

Install the dependencies, including the development tools:

```bash
uv sync
```

## Run the app

```bash
uv run uvicorn gym_app_backend.main:app --reload
```

The API runs at http://127.0.0.1:8000, with interactive docs at http://127.0.0.1:8000/docs.

`--reload` restarts the server whenever the code changes, so use it only during development.

## Run the tests

```bash
uv run pytest
```

## Run with Docker

Build the image:

```bash
docker build -t gym-app-backend .
```

Run a container from it:

```bash
docker run --rm -p 8000:8000 gym-app-backend
```

The API is then available at http://127.0.0.1:8000, the same as when running it locally. Stop the container with Ctrl+C.

The image contains only the app and its runtime dependencies, without the tests or development tools.

## Run with Docker Compose

Docker Compose runs the app and a Postgres database together, each in its own container.

Create your `.env` file from the template, then replace the placeholder values in it:

```bash
cp .env.example .env
```

Build the app image and start both containers:

```bash
docker compose up --build
```

The app starts once the database is ready, and is then available at http://127.0.0.1:8000. `--build` rebuilds the app image first, so it includes your latest code.

Stop both containers with Ctrl+C. `docker compose down` stops them too and also removes them.

### The database

The database keeps its data in a Docker volume, so the data survives the containers being stopped or removed. To delete the database and start again with an empty one:

```bash
docker compose down -v
```

Postgres reads `POSTGRES_USER`, `POSTGRES_PASSWORD` and `POSTGRES_DB` from `.env` only when it creates the database on its first start. Changing them later has no effect until you delete the volume, which also deletes all the data.

To open a `psql` session inside the database container, using the user and database from your `.env`:

```bash
docker compose exec db psql -U <user> -d <database>
```

The database's port 5432 is also published on your machine, and only reachable from it, so you can connect with a local `psql` too:

```bash
psql -h localhost -U <user> -d <database>
```

To start only the database, for example while running the app locally with `--reload`:

```bash
docker compose up db
```
