from flask import Flask, render_template, request
from parser import parse_log_file, filter_by_level

app = Flask(__name__)

LOG_FILE = "logs/app.log"

@app.route("/", methods=["GET", "POST"])
def index():
    logs = parse_log_file(LOG_FILE)

    level = request.form.get("level")
    if level:
        logs = filter_by_level(logs, level)

    return render_template("index.html", logs=logs)

if __name__ == "__main__":
    app.run(debug=True)