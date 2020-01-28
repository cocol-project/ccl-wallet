.DEFAULT_GOAL := development

development:
	shards build ccl-wallet -Dpreview_mt --error-trace --progress

prepare: format ameba test

format:
	crystal tool format $(only)

ameba:
	ameba

test:
	crystal spec --error-trace -t -Dpreview_mt $(spec)
