class Domino < Formula
  desc "Command-line proxy management and independent deployment"
  homepage "https://github.com/KJaebye/domino"
  license "GPL-3.0-only"
  url "https://github.com/KJaebye/domino/releases/download/v1.2.3/domino-runtime-1.2.3.tar.gz"
  version "1.2.3"
  sha256 "12927e78d89e201e99c4e1f8c41d24c0108be970aa7ab1be52b1a1bb2c7921a4"
  depends_on "python@3.13"

  def install
    libexec.install "cli"
    zsh_completion.install libexec/"cli/completion.zsh" => "_domino"
    bash_completion.install libexec/"cli/completion.bash" => "domino"
    { "domino" => "package_cli", "domino-install" => "package_install" }.each do |name, entry|
      (bin/name).write <<~EOS
        #!#{Formula["python@3.13"].opt_bin}/python3.13
        import sys
        sys.path[:0] = ["#{libexec}/cli", "#{libexec}/cli/_vendor"]
        from domino_install import #{entry}
        raise SystemExit(#{entry}())
      EOS
      (bin/name).chmod 0755
    end
    doc.install "README.md", "CHANGELOG.md", "NOTICE", "docs", "licenses"
    doc.install "LICENSE" if File.exist?("LICENSE")
  end

  def caveats
    <<~EOS
      CLI installed. To initialize your local proxy service, run as your normal user:
        domino-install
      Package upgrades do not change running services, configuration, or system proxy.
    EOS
  end

  test do
    system bin/"domino", "--version"
  end
end
