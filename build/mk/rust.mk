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
	@echo "==> Installing Rust components (rust-src, rust-analysis, Rust Language Server, rustfmt)"
	@rustup component add --toolchain stable rust-src rust-analysis rls rustfmt clippy

rust-nightly:			##@languages Install the latest nightly Rust toolchain (uses rustup).
rust-nightly: rustup
	@echo "==> Installing Rust nightly"
	@rustup toolchain install nightly
	@echo "==> Installing Rust components (rust-src)"
	@rustup component add --toolchain nightly rust-src

.PHONY: rustup rust rust-nightly
