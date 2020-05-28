# docker-lazygit

Lazygit on Docker container.


## Usage

Use the original lazygit if possible. See instructions here https://github.com/jesseduffield/lazygit

However, if there is a need to run lazygit in Docker to avoid installation, then run the following to setup a script that starts the docker container with all the correct flags:

```bash
sudo curl https://raw.githubusercontent.com/presidenten/docker-lazygit/master/lg -o /usr/local/bin/lg
sudo chmod a+rx /usr/local/bin/lg
```

Also make sure `/usr/local/bin` is in your path.

For lazygit usage instructions, see original repo: https://github.com/jesseduffield/lazygit


## Drawbacks with docker version

- Credentials helper dont work
- .ssh dir is not synced to container
