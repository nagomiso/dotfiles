#! /usr/bin/python3.9
from __future__ import annotations

import os
import posixpath
import shlex
import signal
import subprocess as sp
import sys

SSH_AGENT_STDOUT_FILE = "/var/tmp/ssh-agent.out"


def read_stdout_file() -> str | None:
    if posixpath.isfile(SSH_AGENT_STDOUT_FILE):
        with open(SSH_AGENT_STDOUT_FILE) as f:
            return f.read()
    return None



def get_ssh_agent_pid_from_file(stdout_file_content: str | None) -> str:
    if stdout_file_content:
        for token in shlex.split(stdout_file_content):
            if token.startswith("SSH_AGENT_PID="):
                _, v = token.rstrip(";").split("=")
                return v
    return ""


def get_ssh_agent_pid_from_pidof() -> str:
    pidof_result = sp.run(
        ["pidof", "ssh-agent"],
        check=False,
        text=True,
        capture_output=True
    )
    return pidof_result.stdout.strip()


def main() -> None:
    stdout_file_content = read_stdout_file()
    pid_from_file = get_ssh_agent_pid_from_file(stdout_file_content)
    pid_from_pidof = get_ssh_agent_pid_from_pidof()
    if pid_from_file and pid_from_pidof and pid_from_file == pid_from_pidof:
        sys.stdout.write(stdout_file_content)
        sys.stdout.flush()
    else:
        for pid in shlex.split(pid_from_pidof):
            try:
                os.kill(int(pid), signal.SIGTERM)
            except OSError as err:
                sys.stderr.write(f"{err}\n")
                sys.stderr.flush()
        ssh_agent_stdout = sp.run(
            ["ssh-agent"],
            text=True,
            capture_output=True,
        ).stdout
        with open(SSH_AGENT_STDOUT_FILE, "w") as f:
            f.write(ssh_agent_stdout)
        sys.stdout.write(ssh_agent_stdout)
        sys.stdout.flush()


if __name__ == "__main__":
    try:
        main()
        sys.exit(0)
    except Exception as err:
        sys.exit(err)
