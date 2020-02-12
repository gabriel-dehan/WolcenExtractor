#!/usr/bin/env ruby
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

def main
  p ARGV
  if ARGV.length != 2
    puts ' Needs two arguments: source (Wolcen installation folder) and destination.'
    puts ' wolcen_extractor.exe C:\Users\username\your\wolcen\installation\folder C:\Users\username\your\destination\folder'
    exit
  end

  source = ARGV[0]
  dest   = ARGV[1]

  raise "Source directory doesn't seem to exist." unless Dir.exists?(source)

  puts " [Reading source: #{source}...]"
  io = PakIO.new(source, dest)

  decrypter = PakDecrypt.new(BASE_RSA, io)
  decrypter.patch!
  
  io.create_dest_folder
  
  decrypter.extract!

  puts " All .pak files extracted to destination: #{dest}"
end

main()


