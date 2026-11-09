from fastapi import FastAPI

app = FastAPI(title="Gym App Backend")


@app.get("/health")
def health() -> dict[str, str]:
    """Report that the API is running."""
    return {"status": "ok"}
