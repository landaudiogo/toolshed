from flask import Flask, render_template, request, redirect, url_for
import subprocess
import time
import os

app = Flask(__name__)

# Global variable for demonstration (in production, use a session or database)

state = False
motion = None
WEBCAM_ADDRESS = os.getenv("WEBCAM_ADDRESS", "http://localhost:8081/")

@app.route("/click", methods=["POST"])
def click():
    global state, motion, WEBCAM_ADDRESS
    state ^= True
    if state: 
        motion=subprocess.Popen(["motion", "-c", "motion.conf"])
        time.sleep(1.5)
    elif state == False and motion != None:
        motion.terminate()

    return redirect(url_for("index"))

@app.route("/", methods=["GET", "POST"])
def index():
    global state
    return render_template("index.html", state="On" if state == True else "Off", WEBCAM_ADDRESS=WEBCAM_ADDRESS)

if __name__ == "__main__":
    app.run(debug=True)
