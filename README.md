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
1. Bind-mount a directory containing your cron task files to `/cron` and a directory containing any scripts you wish to use in cron tasks to `/scripts`
  - If acting on files on another containers volume, bind-mount the existing directory to cronker too to give access
1. Set `PGID` environment variable to desired group id *(for file permissions)*
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
      - PGID=100
      - TZ=America/Los_Angeles
    volumes:
      - /path/to/cron/files:/cron
      - /path/to/scripts:/scripts
      - /path/to/existing/files:/path/to/existing/files # Optional; for working on other service bind-mounted directories
```

### Cron Task

```bash
# Example: Execute script at midnight every day
0 * * * * su -s /bin/bash cronker -c "/scripts/script_to_run.sh" >> /proc/1/fd/1 2>&1
# Must include blank line at the end of the file
```

## TO DO

- [ ] Run as non-root user
  - *Semi-functional with `su -s /bin/bash cronker -c` in cron task execution.*
