# Running

## Docker

```
docker build -t penumbra .
```

Rodar Hello World de `/var/rinha/source.rinha.json`
```
docker run penumbra
```

Rodar arquivo específico
```
docker run -v $PWD/<arquivo>:/var/rinha/source.rinha.json penumbra
```
