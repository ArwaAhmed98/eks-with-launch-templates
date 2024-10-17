import os
import subprocess
import redis
from flask import Flask

app = Flask(__name__)


# Fetch Redis credentials from environment variables
redis_host = os.getenv("REDIS_HOST")
redis_port = int(os.getenv("REDIS_PORT", 6379))
redis_password = os.getenv("REDIS_PASSWORD")

# Establish Redis connection
redis_client = redis.StrictRedis(
    host=redis_host,
    port=redis_port,
    password=redis_password,
    decode_responses=True  # Ensure returned values are strings
)

# Define a route that checks and prints the value of the key
@app.route("/<key>")
def check_key_in_redis(key):
    if redis_client.exists(key):
        value = redis_client.get(key)
        return f"Yes, the key exists. Value: {value}"
    else:
        return f"No, the key '{key}' does not exist."

# Run the Flask app
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
