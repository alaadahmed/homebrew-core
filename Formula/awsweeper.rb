class Awsweeper < Formula
  desc "CLI tool for cleaning your AWS account"
  homepage "https://github.com/jckuester/awsweeper/"
  url "https://github.com/jckuester/awsweeper/archive/v0.12.0.tar.gz"
  sha256 "43468e1af20dab757da449b07330f7b16cbb9f77e130782f88f30a7744385c5e"
  license "MPL-2.0"
  head "https://github.com/jckuester/awsweeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dabe2797d6b3a7f40fa31dff1fc8bc7f7c94918f024f6f866c9fedb43d8ce485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4b48419aaa4619449078a64b28ed9bde4b3bb1c05cf096d6852fa92596f2260"
    sha256 cellar: :any_skip_relocation, monterey:       "54bc928c085313ad7b2cd353bbf4b7e49df992527526348ee0eb01437f9ca87b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1855fe15c7d95a0dddf4487692bf75d6dc234c3ecd25457dffaeab3a2312ece8"
    sha256 cellar: :any_skip_relocation, catalina:       "76710715dee67793f3715dc1a902b18f259b4ed4b42515fbf13b641339b1f899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81776b638e309f839a362f70ba7d0621c2ca9e80f6472f334c5472049cbc3374"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jckuester/awsweeper/internal.version=#{version}
      -X github.com/jckuester/awsweeper/internal.date=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"filter.yml").write <<~EOS
      aws_autoscaling_group:
      aws_instance:
        - tags:
            Name: foo
    EOS

    assert_match "Error: failed to configure provider (name=aws",
      shell_output("#{bin}/awsweeper --dry-run #{testpath}/filter.yml 2>&1", 1)
  end
end
