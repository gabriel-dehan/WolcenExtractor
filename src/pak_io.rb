require 'fileutils'

class PakIO
  attr_reader :dos_source, :dos_dest, :posix_source, :posix_dest, :patterns

  def initialize(dos_source, dos_dest, patterns: nil)
    patterns ||= ""
    
    @dos_source = dos_source
    @posix_source = dos_source.gsub('\\','/')
    @dos_dest = dos_dest
    @posix_dest = dos_dest.gsub('\\','/')
    @patterns = patterns.split(",")
                  .reject { |pat| pat.empty? }
                  .map { |pat| Regexp.new(pat.strip, Regexp::IGNORECASE) }
  end

  def find_files(extension, dest: false)
    Dir.glob("#{dest ? posix_dest : posix_source}/**/*.#{extension}").select do |path|
      if patterns.empty? || dest
        true
      else
        file_name = path.split("/").last
        patterns.any? { |pattern| pattern.match(file_name) }
      end
    end
  end

  def format_path(path, posix: true, with_source: false, with_dest: false)
    formatted_path = path
    src = posix ? posix_source : dos_source
    dst = posix ? posix_dest : dos_dest
    escape = ->(s) { posix ? s.gsub!('\\', '/') : s.gsub!('/', '\\') }

    escape.(path)
    formatted_path.sub!(dst, '')
    formatted_path.sub!(src, '')

    if with_source
      formatted_path = "#{src}#{formatted_path}"
    elsif with_dest
      formatted_path = "#{dst}#{formatted_path}"
    end
    formatted_path
  end

  def directory_has_files?(path, ext)
    !Dir["#{path}*#{ext}"].empty?
  end

  def create_dest_folder
    puts "\n Creating destination folder and replicating source hierarchy..."
    folders = Dir.glob("#{posix_source}/**/")
    folders.each do |folder|
      if directory_has_files?(folder, ".pak")
        FileUtils.mkdir_p(format_path(folder, posix: true, with_dest: true))
      end
    end
    puts " Destination folder created."
  end
end