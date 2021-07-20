## Quick guide

### Pull prebuilt docker image from official docker registry

```
docker pull muzili/tinytex
```
### Build tex files

```
docker run -it --privileged -v $PWD:/ws -w /ws muzili/tinytex xelatex <file.tex>
```

### Convert md to pdf file
```
docker run -it --privileged -v $PWD:/ws -w /ws muzili/tinytex pandoc-default <file.md> -o <file.pdf>
```

## Build the docker image by yourself

### Build

```
docker build -t muzili/tinytex .
```


