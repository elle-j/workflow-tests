.PHONY: \
	format \
	bench \
	test

format:
	cargo fmt --all --check

bench:
	cargo criterion --bench fibonacci --message-format=json \
	    | criterion-table > BENCHMARKS.md

test:
	cargo test --all-targets
