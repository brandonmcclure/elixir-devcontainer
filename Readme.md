# elixir-devcontainer

This is a helper container that I use to run one off Elixir commands, usually to boot strap a project on machines that do not have the Elixir dependencies installed, but do have docker.

![](https://img.shields.io/docker/pulls/bmcclure89/elixir_devcontainer?style=flat-square)
![](https://img.shields.io/docker/image-size/bmcclure89/elixir_devcontainer)

run it with `docker run --rm -it -v ${PWD}:/mnt docker.io/bmcclure/elixir_devcontainer:main`