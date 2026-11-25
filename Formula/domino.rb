class Domino < Formula
  desc "Command-line proxy management and independent deployment"
  homepage "https://github.com/KJaebye/domino"
  license "GPL-3.0-only"
  url "https://github.com/KJaebye/domino/releases/download/v1.3.1/domino-runtime-1.3.1.tar.gz"
  version "1.3.1"
  sha256 "abb7dc619561b05669120dcb8d1a3e7c56a967e880353a90d5a9d373002808e5"
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
