require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.27.tgz"
  sha256 "0529963977e40ed952eac2f84acf4b8fc78f2ff289faa8cb0aceeeecf33e9c87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71e92a2ef4d730ec7895a7d8732bdbfac772a8e00f1a59d60beb9a5b22f88b97"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
