class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.1/libadwaita-1.1.0.tar.xz"
  sha256 "aff598803e810cc28266472cf5bf65e5ed5b90bb3523e206b06b14527325010e"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e180b42f0cfda95c43b8d973eff6112e2a34ad8ccb21e6176802b775ac8fb053"
    sha256 arm64_big_sur:  "1de51d9ddba98d15390d2c3b23f5ff6b07c79086d7fd87e3013276cd7e0e09db"
    sha256 monterey:       "76e1ef7e7be0cac54891951b76925eece61a47a9abf6ace7496f4dee65c3809a"
    sha256 big_sur:        "3727c2f743a37632469ed224b78b8703c85ef0c37a457a7a09ae17ac8390cc7e"
    sha256 catalina:       "001e7972c6a6e6d1e117675bbc6164af899903aa72d0cbab6bc3ce9d2b818506"
    sha256 x86_64_linux:   "d88bd980f437c8500090bd27961da6a12e5dbbe13ae790aa8f96fed28a1b2b8a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sassc" => :build
  depends_on "vala" => :build
  depends_on "gtk4"

  def install
    args = std_meson_args + %w[
      -Dtests=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_FLAGS_NONE);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end
