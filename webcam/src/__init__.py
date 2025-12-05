import tempfile
import os
import subprocess

VIDEO_DEVICE = os.getenv("VIDEO_DEVICE", "/dev/video0")

def start():
    os.chdir(os.path.dirname(__file__))
    with open("motion.conf.template", "rb") as f:
        tmp = tempfile.NamedTemporaryFile(dir="./", delete=True, delete_on_close=True, prefix="motion_", suffix=".conf")
        tmp.write(f.read())
        video_conf = f"videodevice {VIDEO_DEVICE}"
        tmp.write(video_conf.encode())
        tmp.flush()
        command = ["gunicorn", "--workers", "1", "--threads", "10", "-b", "0.0.0.0:8000", "main:app"]
        subprocess.run(command)
