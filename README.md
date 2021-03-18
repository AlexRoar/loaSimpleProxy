# LuaSimpleProxy

Technotrack Tarantool Highload first task

## Config

config.yml
```yaml
---
proxy:
  port: 8098
  bypass:
      host: http://www.tarantool.org/
      port: 80

```

## Usage

Requires tarantool installed

```bash
tarantool proxy.lua
```

Will launch server at localhost:8098 that will redirect requests to http://www.tarantool.org/

**URI sub-directories are also available: http://localhost:8098/en/doc/latest/reference/**

## Photo

<img src="https://github.com/AlexRoar/luaSimpleProxy/raw/main/assets/img1.png">
