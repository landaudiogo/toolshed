import os
import subprocess

def start():
    os.chdir(os.path.dirname(__file__))
    command = ["gunicorn", "--workers", "1", "--threads", "10", "-b", "0.0.0.0:8000", "main:app"]
    subprocess.run(command)
