class Espin < Formula
  desc "Local Streaming ASR for Coding Agents on macOS"
  homepage "https://github.com/ujj/espin"
  url "https://github.com/ujj/espin/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b210f1ddfa710ec46b3177a08f67f6abcb158217178e157b43ddf0026392a501"
  license "MIT"

  depends_on "python@3.11"
  depends_on "uv"

  def install
    libexec.install "espin_gui.py", "pyproject.toml", "uv.lock", "README.md"
    libexec.install "espin"

    (bin/"espin").write <<~SH
      #!/bin/bash
      exec "#{libexec}/.venv/bin/espin" "$@"
    SH

    (bin/"espin-cli").write <<~SH
      #!/bin/bash
      exec "#{libexec}/.venv/bin/espin-cli" "$@"
    SH
  end

  def post_install
    cd libexec do
      system "uv", "sync", "--no-cache"
    end

  end

  def caveats
    <<~EOS
      To start Espin:
        espin

      Then press Ctrl+Option+Space to toggle recording.

      Permissions: Grant your terminal app (Terminal, WezTerm, iTerm, Cursor, etc.)
      Accessibility and Microphone access in:
        System Settings → Privacy & Security
    EOS
  end

  test do
    system (libexec/".venv/bin/python"), "-c", "import espin; import espin.main"
  end
end
