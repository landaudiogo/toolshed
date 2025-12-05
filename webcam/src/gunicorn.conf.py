import sys

def worker_exit(server, worker):
    """
    Called just after a worker has exited.
    :param server: The Arbiter instance (Gunicorn master process)
    :param worker: The Worker instance
    """
    from main import webcam
    if webcam.motion:
        webcam.motion.terminate()
        server.log.info("terminating motion")
    sys.exit(4)
