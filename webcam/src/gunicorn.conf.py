def worker_exit(server, worker):
    """
    Called just after a worker has exited.
    :param server: The Arbiter instance (Gunicorn master process)
    :param worker: The Worker instance
    """
    from main import motion
    if motion:
        motion.terminate()
        server.log.info("terminating motion")
