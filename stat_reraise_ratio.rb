require 'benchmark'
require 'tmpdir'

test_root = Dir.mktmpdir('stat-reraise-ratio')
dirs = 10000.times.map { Dir.mktmpdir('env_dir', test_root) }

iterations = 100
Benchmark.bm(25) do |x|
  x.report("just stat") do
    iterations.times do
      dirs.each do |dir|
        File.stat(dir)
      end
    end
  end

  x.report("stat with rescue") do
    iterations.times do
      dirs.each do |dir|
        begin
          File.stat(dir)
        rescue Errno::EACCES
        end
      end
    end
  end

  x.report("stat with raise and rescue") do
    iterations.times do
      dirs.each do |dir|
        begin
          File.stat(dir)
          raise Errno::EACCES, dir
        rescue Errno::EACCES
        end
      end
    end
  end
end

FileUtils.rm_rf(test_root)
