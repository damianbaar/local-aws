import functools
from pulumi import log

def log_local(message, subsystem):
    """Write the contents of 'message' to the specified subsystem."""
    print('%s: %s' % (subsystem, message))

cli_log = functools.partial(log_local, subsystem='cli')
deployer_log = log