# README

Need to execute tasks on a schedule within a Docker environment?

Need to automate scheduled tasks for existing services?

Cronker brings the scheduling magic of cron to pretty much any Docker environment!

### Notes

- Compatible with both standalone and Swarm mode
- Use [crontab.guru](https://crontab.guru) for a quick and easy way to verify your cron syntax
- Use `>> /proc/1/fd/1 2>&1` at the end of your cron task to have task logs output to standard out for viewing in service logs

## How to Use

1. Use the below Docker Compose example for reference
1. Bind-mount a directory containing a script you wish to use to `/scripts` (*Or use COMMAND for a simple one-liner*)
    - If acting on files on another containers volume, bind-mount the existing directory to cronker too to give access
1. Set `PUID` and `PGID` environment variables to desired user and group ids *(for file permissions)*
1. Spin up the container
1. ???
1. Profit!

## Examples

### Docker Compose
```yml
services:
  cronker:
    image: ghcr.io/mitchnemirov/cronker:prod
    environment:
      - PUID=1000
      - PGID=100
      - TZ=America/Los_Angeles
      - CRON_SCHEDULE=* * * * *
      - COMMAND=echo "Hello" # Command to run - *Only set if not using SCRIPT*
      - SCRIPTS=test.sh,test_two.sh # Scripts to execute from bind-mounted directory - *Only set if not using COMMAND*
    volumes:
      - /path/to/scripts:/app/scripts
      - /path/to/existing/files:/path/to/existing/files # Optional; for working on other service bind-mounted directories
```

## TO DO

- [~] Run as non-root user
  - *Semi-functional with `su -s /bin/bash cronker -c` in cron task execution.*
  - *Technically just makes file permissions easier...*
- [x] Support specifying multiple scripts
