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

rust-nightly:			##@languages Install the latest nightly Rust toolchain (uses rustup).
rust-nightly: rustup
	@echo "==> Installing Rust nightly"
	@rustup toolchain install nightly

.PHONY: rustup rust rust-nightly
