# Image thumbs

To automatically generate image thumbnails create .git/hooks/pre-commit (chmod +x):

```bash
#!/usr/bin/env bash
set -e
echo "Generating thumbnails…"
make thumbs
git add assets/images/thumbs
```
