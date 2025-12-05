from typing import Optional
from flask import Flask, render_template, redirect, url_for, Response
from threading import Lock
from subprocess import Popen
import subprocess
import time
import os
import re


class WebcamState:
    state: bool
    lock: Lock
    motion: Optional[Popen]

    def __init__(self, state: bool, lock: Lock, motion: Optional[Popen] = None):
        self.state = state
        self.lock = lock
        self.motion = motion


app = Flask(__name__)
webcam = WebcamState(False, Lock())
WEBCAM_ADDRESS = os.getenv("WEBCAM_ADDRESS", "http://localhost:8081/")

@app.route("/state", methods=["GET"])
def state():
    with webcam.lock:
        return str(webcam.state)

@app.route("/toggle", methods=["POST"])
def toggle():
    motion_config = None
    for entry in os.listdir():
        if entry.endswith(".conf"):
            motion_config = entry
            break
    if motion_config is not None:
        with webcam.lock:
            webcam.state ^= True
            if webcam.state: 
                r, w = os.pipe()
                webcam.motion = subprocess.Popen(
                    ["motion", "-c", motion_config],
                    stdout=w,
                    stderr=w,
                    text=True,
                    bufsize=1
                )
                with os.fdopen(r, mode="r", encoding="utf-8") as pipe:
                    for line in pipe:
                        if re.search(r"Camera \d+ started", line):
                            break
            elif webcam.state == False and webcam.motion != None:
                webcam.motion.terminate()
                webcam.motion = None

    return Response(status=200)    

@app.route("/click", methods=["POST"])
def click():
    motion_config = None
    for entry in os.listdir():
        if entry.endswith(".conf"):
            motion_config = entry
            break
    if motion_config is not None:
        with webcam.lock:
            webcam.state ^= True
            if webcam.state: 
                r, w = os.pipe()
                webcam.motion = subprocess.Popen(
                    ["motion", "-c", motion_config],
                    stdout=w,
                    stderr=w,
                    text=True,
                    bufsize=1
                )
                with os.fdopen(r, mode="r", encoding="utf-8") as pipe:
                    for line in pipe:
                        if re.search(r"Camera \d+ started", line):
                            break
                    time.sleep(1.5)
            elif webcam.state == False and webcam.motion != None:
                webcam.motion.terminate()
                webcam.motion = None

    return redirect(url_for("index"))

@app.route("/", methods=["GET", "POST"])
def index():
    global state
    with webcam.lock:
        return render_template("index.html", state="On" if webcam.state == True else "Off", WEBCAM_ADDRESS=WEBCAM_ADDRESS)

if __name__ == "__main__":
    app.run(debug=True)
