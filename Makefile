# Makefile for JPEG thumbnails on macOS (handles spaces in filenames)

IMG_DIR     = assets/images
THUMB_DIR   = $(IMG_DIR)/thumbs
THUMB_SIZE  = 400   # longest side in px
QUALITY     = 80    # JPEG quality (0–100)

# Space-safe list of files (NUL-separated internally)
IMAGES := $(shell find "$(IMG_DIR)" -type f \( -iname '*.jpg' -o -iname '*.jpeg' \) ! -path "$(THUMB_DIR)/*" -print0 | xargs -0 -n1 echo)

.PHONY: thumbs build serve clean_thumbs

thumbs:
	@echo "Generating thumbnails..."
	@mkdir -p "$(THUMB_DIR)"
	@find "$(IMG_DIR)" -type f \( -iname '*.jpg' -o -iname '*.jpeg' \) ! -path "$(THUMB_DIR)/*" -print0 \
	| while IFS= read -r -d '' file; do \
	    rel="$${file#$(IMG_DIR)/}"; \
	    out="$(THUMB_DIR)/$$rel"; \
	    mkdir -p "$$(dirname "$$out")"; \
	    sips -Z $(THUMB_SIZE) --setProperty formatOptions $(QUALITY) "$$file" --out "$$out"; \
	    echo "JPEG Thumb: $$out"; \
	  done

build: thumbs
	bundle exec jekyll build

serve: thumbs
	bundle exec jekyll serve --livereload

clean_thumbs:
	rm -rf "$(THUMB_DIR)"