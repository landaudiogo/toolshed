import os
import subprocess

def start():
    os.chdir(os.path.dirname(__file__))
    command = ["gunicorn", "--workers", "1", "main:app"]
    subprocess.run(command)
