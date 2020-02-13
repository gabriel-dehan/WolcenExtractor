require 'rubygems'
require 'commander'
require 'zip'
require_relative './pak_io.rb'
require_relative './pak_decrypt.rb'

BASE_RSA = %[
  30 81 89 02 81 81 00 E2 72 5E F9 BB 16 88 71 C2
  38 D9 1B 64 CF B8 B1 33 2F 1B BC F1 05 F4 0F 25
  2F B9 3F 3A 60 9D 52 4C F8 F5 EE 09 BC 55 4F D9
  18 DB 8B B3 53 1D 6F 88 BE FE A4 BF BD F5 1C B1
  E1 DF 5E 5D FA 83 FD 65 84 D3 7E 27 99 24 22 4F
  C4 F8 BB 6C 98 ED 50 D2 70 02 E8 BA 21 F3 5F 01
  55 A0 8D 9E D2 76 71 40 32 AE EC DA 06 6C 17 FA
  54 F1 C3 3E 5D AF 8B 33 2B 3C C0 77 14 90 A1 52
  61 B2 DD 90 8F 53 F1 02 03 01 00 01
]

Commander.configure do
  program :name, 'Wolcen Extractor'
  program :version, '1.0.0'
  program :description, 'Extracts Pak files from Wolcen. decrypts CryXML.'

  command :patch do |c| 
    c.syntax = 'wolcen_extractor.exe patch [options]'
    c.description = 'Patches PakDecrypt with the latest Wolcen RSA key'
    c.option '--source "<Wolcen folder>"', String, 'Your wolcen installation folder.'
    
    c.action do |args, options|
      if !options.source
        puts "\n  Missing argument: --source \"<Wolcen folder>\""
        puts "  You can use 'wolcen_extractor.exe patch --help' to get more information."
        exit
      end

      unless Dir.exists?(options.source)
        puts "  --source #{options.source}, directory doesn't seem to exist." 
        exit
      end

      puts " [Found source: #{options.source}]"
      io = PakIO.new(options.source, "")

      decrypter = PakDecrypt.new(BASE_RSA, io)
      decrypter.patch!
      
      puts "\n PakDecrypt.exe can now be found in #{Dir.pwd.gsub('/', '\\')}\\bin\\PakDecrypt.exe"
    end
  end


  command :extract do |c| 
    c.syntax = 'wolcen_extractor.exe extract [options]'
    c.description = 'Patches PakDecrypt with the latest Wolcen RSA key and then extract every .pak file to the destination folder.'
    c.option '--source "<Wolcen folder>"', String, 'Your wolcen installation folder.'
    c.option '--dest "<Destination folder>"', String, 'A destination folder. It doesn\'nt need to exist.'
    c.option '--only "<pattern>"', String, 'Will only extract .pak files with names matching the provided pattern, e.g --pattern "lib,umbra".'
    c.option '--no-patch', TrueClass, 'Will prevent the program from patching PakDecrypt.'
    
    c.action do |args, options|
      if !options.source
        puts "\n  Missing argument: --source \"<Wolcen folder>\""
        puts "  You can use 'wolcen_extractor.exe extract --help' to get more information."
        exit
      end

      if !options.dest
        puts "\n  Missing argument: --dest \"<Destination folder>\""
        puts "  You can use 'wolcen_extractor.exe extract --help' to get more information."
        exit
      end

      unless Dir.exists?(options.source)
        puts "  --source #{options.source}, directory doesn't seem to exist." 
        exit
      end

      puts " [Found source: #{options.source}]"
      io = PakIO.new(options.source, options.dest, patterns: options.only)

      decrypter = PakDecrypt.new(BASE_RSA, io)

      unless options.no_patch
        decrypter.patch!
      end

      io.create_dest_folder
      decrypter.extract!

      puts "\n All .pak files extracted to destination: #{options.dest}"
    end
  end
end



