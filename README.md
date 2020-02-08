# Wolcen Extractor

/!\ Windows only /!\\ 

This program allows the unpacking of Wolcen `.pak` files and the decryption of CryEngine XML files. 
It is only usable from the command line (`cmd`) on Windows (Works for sure on Windows 10, not sure about previous versions).

For this program to work, you need to provide the latest Wolcen's build CryEngine RSA Key. 
I'll try to keep it up to date for as long as I can (and as long as I can manage to retrieve it, Wolcen might change some things in the future.)
If you can't find a release for the latest version of Wolcen, you can try to extract the RSA Key yourself by following [this tutorial](http://atom0s.com/forums/viewtopic.php?f=11&t=223).
After you found it, you can just copy paste it in the `wolcen.rsa` file at the root of the folder. A new patched PakDecrypt executable will be automatically created when you run the program.

## Disclaimer

This will not give you access to Wolcen's source code, but it will unpak assets (useful if you want to get item pictures, UI elements, etc...), configuration files and other data files. Keep in mind that those are still the proprerty of © Wolcen Studio. Don't use them for non Wolcen-related community projects and keep in mind that © Wolcen Studio may shutdown any project using their assets and data. I just hope they leave the community free to create amazing tools :)

## Installation

[Download the latest Release](https://github.com/gabriel-dehan/WolcenExtractor/releases) and extract it in it's own directory, wherever you want.

## Usage

Basic usage is the following

```
wolcen_extractor.exe <source> <destination>
```


Either open Windows `cmd` and navigate to the folder containing `wolcen_extractor.exe`
OR (if you don't know how to)
Go the the WolcenExtractor directory and `Shift`+`Right-Click` then select "Open command window here" or "Open Windows PowerShell window here".
Then you can run the program. 

This program needs two things: the source folder and a destination folder. 
- For the source, usually you'll want to locate your Wolcen installation and in it, the `Game` folder. Mine is in `C:\Program Files (x86)\Steam\steamapps\common\Wolcen\Game`. This will be your source, it's the folder that contains all `.pak` files.
- For the destination, it can be whatever you want, either a relative path like `./extracts` (this would extract everything in an `extract` folder in the WolcenExtractor directory) or an absolute path like `C:\Users\princ\Documents\WolcenUnpacked`.

Then you can use the software, in the command line (cmd or powershell) write

```
wolcen_extractor.exe C:\Program Files (x86)\Steam\steamapps\common\Wolcen\Game C:\Users\princ\Documents\WolcenUnpacked
```

It **will** take some time (10-20 minutes) as every `.pak` file needs to be extracted and inside, all CryXML and DDS files need to be converted.

## Troubleshooting

- Sometimes, the execution hangs during a DDS conversion phase, in this case, just hitting enter usually solves the issue.
- Some `DDS` files just can't be converted by image magick, and will be left as is. You can still open those in Photoshop, Gimp, Paint.net (with the necessary plugin) or a DDS Viewer or converter.

## Dev

Clone the repository and install Ruby 2.1.9.

```
bundle install
ruby src/main.rb some\path\to\your\source some\path\to\your\destination
```

## Build 

Requires ruby 2.1.9 because of ocra's compatibility. This script doesn't require more recent ruby features so it should be fine.

```
gem install bundler
gem install ocra
bundle install
ocra src/main.rb src/pak_decrypt.rb src/pak_io.rb --verbose --gem-full --no-dep-run --add-all-core --gemfile .\Gemfile
```


## Roadmap: 

- Find the necessary RSA upon release and publish a new version on February 14.

## Inspiration and Resources

Thanks to atom0s for all his knowledge and his great tutorials.
- http://atom0s.com/forums/viewtopic.php?f=11&t=223
- https://zenhax.com/viewtopic.php?p=41911#p41911

### Current Wolcen PakDecrypt RSA Key:

```
30 81 89 02 81 81 00 E2 72 5E F9 BB 16 88 71 C2 38 D9 1B 64 CF B8 B1 33 2F 1B BC F1 05 F4 0F 25 2F B9 3F 3A 60 9D 52 4C F8 F5 EE 09 BC 55 4F D9 18 DB 8B B3 53 1D 6F 88 BE FE A4 BF BD F5 1C B1 E1 DF 5E 5D FA 83 FD 65 84 D3 7E 27 99 24 22 4F C4 F8 BB 6C 98 ED 50 D2 70 02 E8 BA 21 F3 5F 01 55 A0 8D 9E D2 76 71 40 32 AE EC DA 06 6C 17 FA 54 F1 C3 3E 5D AF 8B 33 2B 3C C0 77 14 90 A1 52 61 B2 DD 90 8F 53 F1 02 03 01 00 01
```
