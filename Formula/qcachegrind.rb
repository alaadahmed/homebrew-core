class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://download.kde.org/stable/release-service/21.12.0/src/kcachegrind-21.12.0.tar.xz"
  sha256 "9e8a59946d54508217f865ab343d26c50165c8d593b651bc4ac798d33c7eaecc"
  license "GPL-2.0-or-later"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b1a7d9835d9d2bc1e16b6850461132432f61ed9732efc3a5ed90ed96df17665b"
    sha256 cellar: :any,                 big_sur:       "bc52c006c8bfe8a66531719a20bd2378d7f315a62e9fb72f57878e55b220c0cb"
    sha256 cellar: :any,                 catalina:      "6b70d5458a69a1dd4ee9c480d24bb806e4756f56072e97b230364f4f1ad89e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50a359f8ade4ebe627deac699b65d76852df7b822f12fcd4abff987511925055"
  end

  depends_on "graphviz"
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = ["-config", "release", "-spec"]
    os = OS.mac? ? "macx" : OS.kernel_name.downcase
    compiler = ENV.compiler.to_s.start_with?("gcc") ? "g++" : ENV.compiler
    arch = Hardware::CPU.intel? ? "" : "-#{Hardware::CPU.arch}"
    args << "#{os}-#{compiler}#{arch}"

    system Formula["qt@5"].opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
