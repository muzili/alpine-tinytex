## Build

```
docker build -t muzili/tinytex .
```

## Run

```
docker run -it --privileged -v $PWD:/ws -w /ws muzili/tinytex xelatex <file.tex>
```
