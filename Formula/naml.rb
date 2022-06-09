class Naml < Formula
  desc "Convert Kubernetes YAML to Golang"
  homepage "https://github.com/kris-nova/naml"
  url "https://github.com/kris-nova/naml/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "0842633268b06be82db4dd10c3c938f756f613c44c15c2d935b933409da8c4bd"
  license "Apache-2.0"
  head "https://github.com/kris-nova/naml.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8620c41653aff4870bcc091d644b0f6845a38cb344c18ba61673fe4ef6bd04a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "731c3edcac16fcce065e0bf79674ca20273a2874cb0a28e0dd3aa4b354a46a9d"
    sha256 cellar: :any_skip_relocation, monterey:       "2171e40ba252fb5716f30dc8cf05d2a83ea88616c92ed5c2b9e45d48f6521061"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e4965a3e7d56956ba85367b8bb70bf78e096dd3cf2f07648c2e0efcfff503aa"
    sha256 cellar: :any_skip_relocation, catalina:       "badeb70412ea16c9b1e98efb7889cb6145d0f44a090c0d688b5e331c913c2cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfb2de73a6ca925bdb4599464e3e7759bcb823900ee2fe5ba0d0c3e4bb27d0c3"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/kris-nova/naml.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  test do
    assert_match "Not Another Markup Language", shell_output("#{bin}/naml list")

    (testpath/"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Namespace
      metadata:
        name: brewtest
    EOS

    assert_match "Application autogenerated from NAML v#{version}",
      pipe_output("#{bin}/naml codify", (testpath/"service.yaml").read)
  end
end
