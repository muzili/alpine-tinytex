## Quick guide

### Pull prebuilt docker image from official docker registry

```
podman pull muzili/tinytex
```
### Build tex files

```
podman run -it -v $PWD:/ws -w /ws muzili/tinytex xelatex <file.tex>
```

### Convert md to pdf file
```
podman run -it -v $PWD:/ws -w /ws muzili/tinytex pandoc-default <file.md> -o <file.pdf>
```

## Build the docker image by yourself

### Build

```
podman build -t muzili/tinytex .
```


