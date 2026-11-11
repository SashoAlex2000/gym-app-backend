# Gym App Backend

Backend for a gym logging app, built with FastAPI.

## Requirements

- [uv](https://docs.astral.sh/uv/)
- Python 3.14 (uv downloads it if it isn't installed)

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
