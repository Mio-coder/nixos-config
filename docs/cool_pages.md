https://github.com/compose-spec/compose-spec/blob/main/05-services.md#devices
```yaml
services:
  ollama:
    # ...
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```
turns into
```yaml
services:
  ollama:
    # ...
    devices:
      - nvidia.com/gpu=all

```
