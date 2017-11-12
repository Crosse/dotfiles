RUSTUP_PATH := ${HOME}/.rustup

$(RUSTUP_PATH):
	@echo "==> Installing rustup"
	@curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y

rustup:				##@env Install rustup (Not really a **env, but still a language manager).
rustup: $(RUSTUP_PATH)

rust:				##@languages Install the latest stable Rust toolchain (uses rustup).
rust: rustup
	@echo "==> Installing Rust stable"
	@rustup toolchain install stable
	@echo "==> Installing Rust components (rust-src, rust-analysis, Rust Language Server)"
	@rustup component add --toolchain nightly rust-src rust-analysis rls-preview

rust-nightly:			##@languages Install the latest nightly Rust toolchain (uses rustup).
rust-nightly: rustup
	@echo "==> Installing Rust nightly"
	@rustup toolchain install nightly
	@echo "==> Installing Rust components (rust-src, rust-analysis, Rust Language Server)"
	@rustup component add --toolchain nightly rust-src rust-analysis rls-preview
	@echo "==> Installing nightly-only tools (clippy)"
	@cargo install +nightly clippy
	@cargo install +nightly rustfmt-nightly

rust-tools:			##@languages Install some useful Rust tools (cargo watch, racer, ripgrep).
rust-tools: rustup
	@echo "==> Installing Rust tools"
	@cargo install cargo-watch || true
	@cargo install racer || true
	@cargo install ripgrep || true

rust-tools-update:
	@for tool in $$(cargo install --list | awk '/:/ { print $$1 }'); do   \
	    cargo install -f $$tool;					    \
	done
.PHONY: rustup rust rust-nightly
