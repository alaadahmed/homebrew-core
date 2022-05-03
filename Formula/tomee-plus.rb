class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.11/apache-tomee-8.0.11-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.11/apache-tomee-8.0.11-plus.tar.gz"
  sha256 "02e64e23ee56161634e6061be19137274223e700c6302944d8b70cd70a52263d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e931b44193aaab8ca2122ee283abad14da8a407f0507b01fb3bf053bc2ee962"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    (bin/"tomee-plus-startup").write_env_script "#{libexec}/bin/startup.sh",
                                                Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Apache TomEE Plus is:
        #{opt_libexec}
      To run Apache TomEE:
        #{opt_libexec}/bin/tomee-plus-startup
    EOS
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
