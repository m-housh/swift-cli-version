DOCC_TARGET ?= GitVersion
DOCC_BASEPATH = $(shell basename "$(PWD)")
DOCC_DIR ?= ./docs

build-and-run:
	swift run build-example
	./.build/debug/example --help
	./.build/debug/example

build-documentation:
	swift package \
		--allow-writing-to-directory "$(DOCC_DIR)" \
		generate-documentation \
		--target "$(DOCC_TARGET)" \
		--disable-indexing \
		--transform-for-static-hosting \
		--hosting-base-path "$(DOCC_BASEPATH)" \
		--output-path "$(DOCC_DIR)"

preview-documentation:
	swift package \
		--disable-sandbox \
		preview-documentation \
		--target "$(DOCC_TARGET)"
