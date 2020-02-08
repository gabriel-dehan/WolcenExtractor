require 'fileutils'
require 'rubygems'
require 'zip'

class PakDecrypt
  attr_reader :io, :base_rsa, :new_rsa

  def initialize(base_rsa, io)
    @io = io
    @base_rsa = base_rsa
    @new_rsa = File.read('./wolcen.rsa')
  end
  
  def patch!
    # Make sure we don't have an old PakDecrypt patch
    FileUtils.rm('.\bin\PakDecrypt.exe', force: true)
    # Copy the Unpatched to PakDecrypt
    FileUtils.cp('.\bin\PakDecrypt_Unpatched.exe', '.\bin\PakDecrypt.exe')

    # Read as hexadecimal
    exe = File.binread('.\bin\PakDecrypt.exe').unpack("H*").first
    brsa = clean_rsa(base_rsa)
    nrsa = clean_rsa(new_rsa)
   
    if exe.include?(brsa)
      patched_exe = exe.gsub(brsa, nrsa)
      File.open('.\bin\PakDecrypt.exe', 'w+b') do |file|
        file.write([patched_exe].pack('H*'))
      end
    end
    puts "PakDecrypt is now patched.\n"
  end

  def clean_rsa(rsa)
    rsa.gsub(/\s/, '').downcase
  end

  def extract!
    pak_files = io.find_files("pak")
    puts "Found #{pak_files.length} .pak files.\nUnpacking..."
    pak_files.each do |pak_file|
      unpaked_file = unpak!(pak_file)
      pak_folder = unzip!(unpaked_file)
      puts "#{io.format_path(pak_file)} unpacked."

      xml_files = io.find_files("xml", dest: true)
      puts "-> Found #{xml_files.length} .xml files."
      puts "-> Decrypting CryXML...\n"
      xml_files.each do |xml_file|
        decrypt_xml!(xml_file)
      end
    end
  end

  def unpak!(pak_file)
    source = io.format_path(pak_file, posix: false, with_source: true)
    dest = io.format_path(pak_file, posix: false, with_dest: true).gsub('.pak', '.zip')
    system('.\bin\PakDecrypt_Unpatched.exe', source, dest, out: File::NULL)
    dest
  end

  def unzip!(unpaked_file)
    source = unpaked_file 
    dest = File.dirname(unpaked_file)

    Zip::File.open(source) do |zip_file|
      zip_file.each do |f|
        path = File.join(dest, f.name)
        FileUtils.mkdir_p(File.dirname(path))
        zip_file.extract(f, path) unless File.exist?(path)
      end
    end
    FileUtils.rm(source)
  end

  def decrypt_xml!(xml_file)
    source = io.format_path(xml_file, posix: false, with_dest: true)

    first_line = File.open(source, 'r:utf-8') {|f| f.readline}
    first_line.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    needsToDecrypt = !!first_line.match(/^CryXml/i)

    if needsToDecrypt
      system('.\bin\DataForge2.exe', source, out: File::NULL)
    end
    
    source
  end
end