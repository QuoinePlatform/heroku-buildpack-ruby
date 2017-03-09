class LanguagePack::NodeInstaller
  attr_reader :version

  def initialize
    nodebin = LanguagePack::Nodebin.node_lts
    @version = nodebin["number"]
    @url     = nodebin["url"]
    @fetcher = LanguagePack::Fetcher.new("")
  end

  def binary_path
    node_folder(@version)
  end

  def install
    Dir.mktmpdir do |dir|
      node_bin = "#{binary_path}/bin/node"
      npm_bin  = "#{binary_path}/lib/node_modules/npm"

      Dir.chdir(dir) do
        @fetcher.fetch_untar(@url, "#{node_bin} #{npm_bin}")
      end

      FileUtils.mv("#{dir}/#{node_bin}", ".")
      FileUtils.mv("#{dir}/#{npm_bin}", "../vendor")
    end
  end

  private
  def node_folder(version)
    "node-v#{version}-linux-x64"
  end
end
