FROM python:3.14-slim

# Install uv by copying its binary from the official uv image.
COPY --from=ghcr.io/astral-sh/uv:0.13.7 /uv /uvx /bin/

# Compile packages to bytecode for faster startup, copy files from uv's cache
# instead of linking them, use the image's Python instead of downloading one,
# and send Python output straight to the logs.
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=0 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install the dependencies first, as their own layer. Docker reuses this layer
# until pyproject.toml or uv.lock changes, so code changes rebuild quickly.
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-dev

# Copy the project in and install it.
COPY . /app
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev

# Run as an unprivileged user instead of root.
RUN groupadd --system --gid 999 app \
    && useradd --system --gid 999 --uid 999 --no-create-home app
USER app

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8000

# Report the container as unhealthy if /health stops responding.
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --start-interval=2s --retries=3 \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=2)"]

CMD ["uvicorn", "gym_app_backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
