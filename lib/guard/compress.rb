require "guard"
require "guard/plugin"
require "pathname"

module Guard
  class Compress < Plugin
    MissingInputOption = Class.new(ArgumentError)
    class FakeCompressor
      def compress(stuff)
        stuff
      end
    end

    def initialize(opts = {})
      raise(MissingInputOption, "missing :input") unless opts.key?(:input)

      opts[:input] = Array(opts[:input])
      opts[:watchers].concat(opts[:input].map { |i| Guard::Watcher.new(i) })

      super(opts)
    end

    def compress(paths)
      paths.each do |path|
        compressor = compressor_for(path)
        content = File.read(path)
        compressed_content = compressor.compress(content)
        filename = output_path(path)
        File.open(filename, "w") { |f| f.write(compressed_content) }
      end
    end

    def compressor_for(file)
      if file =~ /\.css$/
        YUI::CssCompressor.new
      elsif file =~ /\.js$/
        YUI::JavaScriptCompressor.new(munge: munge)
      else
        FakeCompressor.new
      end
    end

    def run_all
      raise "I don't know what to do here"
    end

    def run_on_changes(paths)
      compress(paths)
      Guard::Notifier.notify "Compressed #{@ouput}"
    end

    def run_on_removals(paths)
      paths.each do |path|
        FileUtils.rm output_path(path)
      end
    end

    def input
      options.fetch(:input)
    end

    def output
      options.fetch(:output) { ":file#{compressed_extension}" }
    end

    def compressed_extension
      options.fetch(:compressed_extension) { ".min:ext" }
    end

    def output_path(path)
      pathname = Pathname.new(path)
      ext = pathname.extname
      file = pathname.basename(ext)
      output.gsub(/:file/, file).gsub(/:ext/, ext)
    end

    def munge
      options.fetch(:munge) { true }
    end
  end
end

require "guard/compress/version"
