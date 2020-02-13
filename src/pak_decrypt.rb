require 'fileutils'
require 'rubygems'
require 'zip'

class PakDecrypt
  attr_reader :io, :base_rsa, :new_rsa

  def initialize(base_rsa, io)
    @io = io
    @base_rsa = base_rsa
    @new_rsa = File.read('./wolcen.rsa')
    @converted_xml = []
    @converted_dds = []
  end
  
  def patch!
    # Dumping wolcen's RSA key
    puts "\n [Dumping Wolcen's RSA key...]"

    source = io.format_path('\win_x64\CryGameSDK.dll', posix: false, with_source: true)

    if !File.exist?(source)
      puts " \"#{io.dos_source}\" doesn't seem to be your Wolcen installation folder."
      puts " Exiting..."
      exit
    end
    system('.\bin\wolcen_keydumper.exe --file ' + '"' + source + '"' + ' --outfile .\wolcen.rsa.bin')
    hexrsa = File.binread('.\wolcen.rsa.bin').unpack("H*").first
    File.open('.\wolcen.rsa', 'w') do |file|
      file.write(hexrsa)
    end
    FileUtils.rm('.\wolcen.rsa.bin', force: true)
    puts " [Wolcen's RSA key found!]"

    puts "\n [Patching PakDecrypt...]"
    # Make sure we don't have an old PakDecrypt patched
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
    puts " [PakDecrypt is now patched!]"
  end

  def clean_rsa(rsa)
    rsa.gsub(/\s/, '').downcase
  end

  def extract!
    pak_files = io.find_files("pak")
    puts "\n Unpacking #{pak_files.length} .pak files..."
    pak_files.each do |pak_file|
      puts "\n + Unpacking #{io.format_path(pak_file)}..."
      unpaked_file = unpak!(pak_file)
      pak_folder = unzip!(unpaked_file)
      puts " +-> Unpacked."

      xml_files = io.find_files("xml", dest: true)
      puts " +-> Found #{xml_files.length} .xml files."
      puts " +-> Decrypting CryXML...\n"
      xml_files.each do |xml_file|
        decrypt_xml!(xml_file)
      end
      puts " +-> XML Decrypted."

      # dds_files = io.find_files("dds", dest: true)
      # puts " +-> Found #{dds_files.length} .dds files."
      # puts " +-> Converting DDS to PNGs...\n"
      # dds_files.each do |dds_file|
      #   convert_dds!(dds_file)
      # end
      # puts " +-> DDS Converted."
    end
  end

  def unpak!(pak_file)
    source = io.format_path(pak_file, posix: false, with_source: true)
    dest = io.format_path(pak_file, posix: false, with_dest: true).gsub('.pak', '.zip')
    system('.\bin\PakDecrypt.exe', source, dest, out: File::NULL)
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

    unless @converted_xml.include?(source)
      first_line = File.open(source, 'r:utf-8') {|f| f.readline}
      first_line.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      needsToDecrypt = !!first_line.match(/^CryXml/i)
      
      if needsToDecrypt
        # Decrypt CryXML and create .raw file
        system('.\bin\DataForge2.exe', source, out: File::NULL)
        # Remove encrypted CryXML file
        FileUtils.rm(source)
        # Rename generated raw files to XML with same name as the source
        raw_file_path = source.gsub('.xml', '.raw')
        File.rename(raw_file_path, source)
      end

      @converted_xml << source
    end
      
    source
  end

  def convert_dds!(dds_file)
    source = io.format_path(dds_file, posix: false, with_dest: true)

    unless @converted_dds.include?(source)
      begin 
        # puts '.\bin\magick.exe mogrify -format png ' + source
        system('.\bin\magick.exe mogrify -format png ' + source, out: File::NULL)
      rescue 
        puts " Couldn't convert #{source}"
      end

      @converted_dds << source
    end
  end
end
