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

## "No Apps available" when clicking a URL
https://github.com/flatpak/xdg-desktop-portal-gtk/issues/440#issuecomment-1900520919
