# Wolcen Extractor

* [What is this about](#what-is-this-about)
* [Disclaimer](#disclaimer)
* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
  + [Basic usage](#basic-usage)
  + [Advanced usage](#advanced-usage)
    - [Extracting only certain pak files](#extracting-only-certain-pak-files)
    - [Extracting only ONE very specific pak file](#extracting-only-one-very-specific-pak-file)
    - [Only patching PakDecrypt.exe with the latest Wolcen RSA key](#only-patching-pakdecryptexe-with-the-latest-wolcen-rsa-key)
    - [Only decrypt CryXML](#only-decrypt-cryxml)
* [Troubleshooting](#troubleshooting)
* [Want to contribute?](#want-to-contribute-)
  + [Building the executable](#building-the-executable)
* [Roadmap](#roadmap-)
* [Inspiration and Resources](#inspiration-and-resources)
* [Current Wolcen PakDecrypt RSA Key](#current-wolcen-pakdecrypt-rsa-key)

## What is this about 

/!\ This program is for Windows only /!\\ 

This program allows the unpacking of Wolcen `.pak` files and the decryption of CryEngine XML files. 
It is only usable from the command line (`cmd`) on Windows (Works for sure on Windows 10, not sure about previous versions as I haven't tested it.).

This program makes use of atom0s Wolcen's RSA keydumper to retrieve the RSA key used for decrypting pak files. The RSA Key is then written to an `wolcen.rsa` file in this program's folder if you ever need it.

## Disclaimer

This will not give you access to Wolcen's source code, but it will unpak assets (useful if you want to get item pictures, UI elements, etc...), configuration files and other data files. Keep in mind that those are still the proprerty of © Wolcen Studio. Don't use them for non Wolcen-related community projects and keep in mind that © Wolcen Studio may shutdown any project using their assets and data. I just hope they leave the community free to create amazing tools :)

## Requirements

Some binaries used by this application were created using Visual Studio 2019, thus require a specific runtime to work. 
You can find the required runtime on Microsoft's website here:
https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads

You need to download the Visual Studio 2015, 2017 and 2019 x86 file. 
Beware as you DON'T WANT the 64bit version, you must install the 32bit (x86) file for this to work!

## Installation

[Go to the latest Release](https://github.com/gabriel-dehan/WolcenExtractor/releases), download **WolcenExtractor.zip** and extract it in it's own directory, wherever you want.

## Usage

### Basic usage

Basic usage is the following:

```
wolcen_extractor.exe extract --source "<wolcen install folder>" --dest "<destination>"
```

Either open Windows `cmd` and navigate to the folder containing `wolcen_extractor.exe`
OR (if you don't know how to)
Go the the WolcenExtractor directory and `Shift`+`Right-Click` then select "Open command window here" or "Open Windows PowerShell window here".

> Please note that you NEED TO BE IN THE `WolcenExtractor` DIRECTORY before running the program, this is VERY important otherwise the program work. This means that running the program by doing something like `D:\Downloads\Wolcen\WolcenExtractor\wolcen_extractor.exe` won't work. Use the aforementioned instructions to navigate to the proper directory in the command line interface.

Once you are in the WolcenExtractor directory, you can then run the program. 

This program needs two things: the source folder and a destination folder. 
- For the source, you'll want to locate your Wolcen installation folder. Mine is in `C:\Program Files (x86)\Steam\steamapps\common\Wolcen`. This will be your source, as it contains all `.pak` files in its subdirectories.
- For the destination, it can be whatever you want, either a relative path like `./extracts` (this would extract everything in an `extract` folder in the WolcenExtractor directory) or an absolute path like `C:\Users\princ\Documents\WolcenUnpacked`.

In the command line (cmd or powershell) write:

```
wolcen_extractor.exe extract --source "C:\Program Files (x86)\Steam\steamapps\common\Wolcen" --dest "C:\Users\princ\Documents\WolcenUnpacked"
```
Note the `"` quotes around the source and destination. Those are often necessary if there are spaces in your path, it is better to add them in all cases.

When extracting everything. it **will** take some time (up to 20-30 minutes) as every `.pak` file needs to be extracted and inside, all CryXML files need to be decrypted.
Also keep in mind that the unpacked folder will be roughly the size of your Wolcen's installation (dozens of gb) so you need to have enough space on your disk. For the beta the whole extracted installation folder took up to 15GB.
If you don't want to extract everything but only a few pak files, refer to the [Advanced usage](#advanced-usage) section below.

### Advanced usage

Remember you can always use `wolcen_extractor.exe --help` and `wolcen_extractor.exe [command] --help` to get more information.

#### Extracting only certain pak files

You might not want to extract EVERYTHING in the Wolcen directory as it takes up a lot of space and takes a lot of time. If you want to restrict the files that will be extracted you can use the `--only` flag.

Example: 
```
wolcen_extractor.exe extract --source "C:\Program Files (x86)\Steam\steamapps\common\Wolcen" --dest "C:\Users\princ\Documents\WolcenUnpacked" --only "lib,umbra"
```
The use of the flag `--only "lib,umbra"` will make the program only extract `.pak` files that have the words `lib` or `umbra` in their name. 
You can search for anything for the pattern as long as the values are comma separated and the pattern is case insensitive. If you only have one pattern to match you can of course write `--only "umbra"` to match only files with `umbra` in their name.

#### Extracting only ONE very specific pak file

Same as above, you can use the `--only` option :) 

Example: 
```
wolcen_extractor.exe extract --source "C:\Program Files (x86)\Steam\steamapps\common\Wolcen" --dest "C:\Users\princ\Documents\WolcenUnpacked" --only "umbra.pak"
```

The `--only "umbra.pak"` will only extract the file with the exact name "umbra.pak" 

#### Only patching PakDecrypt.exe with the latest Wolcen RSA key

If for some reason you want to only get an up to date `PakDecrypt.exe` that works with the latest version of Wolcen so you can use it yourself, you can use: 

```
wolcen_extractor.exe patch --source "C:\Program Files (x86)\Steam\steamapps\common\Wolcen"
```
It will patch `PakDecrypt.exe` and then provide you with the patched file location.
You can use `wolcen_extractor.exe patch --help` for more information.

Note that once you have patched your `PakDecrypt.exe` can also extract using this program as usual but providing the `--no-patch` flag.
```
wolcen_extractor.exe extract --source "C:\Program Files (x86)\Steam\steamapps\common\Wolcen" --dest "C:\Users\princ\Documents\WolcenUnpacked" --no-patch
```
Will extract all `.pak` files but without patching `PakDecrypt.exe` first.

#### Only decrypt CryXML

To do this you can just go to `/bin` folder and use `RuneForge2.exe <sourcexml>` for XML decryption. Or even just drag'n'drop an XML file (or many iirc) onto `RuneForge2.exe` in the explorer. This will create a `.raw` file that you can then rename to `.xml`.

## Troubleshooting

- The **program is slow to start** (10-15 seconds) and that's "normal". I am by no mean a software developer and my main language is Ruby which is not meant for software development or the release of executables. This means that before my code can load, it needs to load Ruby before executing my code which is  the reason for the slow start.
- Be careful not to leave any trailing backslash to your `--source` or `--destination`: `wolcen_extractor.exe extract --source "C:\Program Files (x86)\Steam\steamapps\common\Wolcen\"` will cause an error whereas `wolcen_extractor.exe extract --source "C:\Program Files (x86)\Steam\steamapps\common\Wolcen"` will work.
- When using **Windows Powershell** you need to add a `.\` before the name of the program. This means that instead of `wolcen_extractor.exe ...` you need to write `.\wolcen_extractor.exe`. 

/!\ DDS converting is buggy at the moment so I have deactivated it until I find a better way of handling it /!\
- Sometimes, the execution hangs during a DDS conversion phase, in this case, just hitting enter usually solves the issue.
- Some `DDS` files just can't be converted by image magick, and will be left as is. You can still open those in Photoshop, Gimp, Paint.net (with the necessary plugin) or a DDS Viewer or converter.

## Want to contribute?

Install Ruby 2.1.9 (x86 NOT x64) and clone the repository.

```
gem install bundler -v 1.16.0
bundle install
ruby src/main.rb extract --source some\path\to\your\source --dest some\path\to\your\destination
```

Make your changes and then do a PR ;) 

### Building the executable

Requires ruby 2.1.9 because of ocra's compatibility. This script doesn't require more recent ruby features so it should be fine.

```
gem install bundler -v 1.16.0
gem install ocra
bundle install
ocra src/main.rb src/pak_decrypt.rb src/pak_io.rb --verbose --gem-full --add-all-core --gemfile .\Gemfile
```

## Roadmap: 

- Find a way to convert DDS that works for all files and is not buggy.
- Add extraction for cgf files (https://github.com/Markemp/Cryengine-Converter)

## Inspiration and Resources

Thanks to atom0s for all his knowledge and his great tutorials.
- http://atom0s.com/forums/viewtopic.php?f=11&t=223
- https://zenhax.com/viewtopic.php?p=41911#p41911

## Current Wolcen PakDecrypt RSA Key

```
30 81 89 02 81 81 00 E2 72 5E F9 BB 16 88 71 C2 38 D9 1B 64 CF B8 B1 33 2F 1B BC F1 05 F4 0F 25 2F B9 3F 3A 60 9D 52 4C F8 F5 EE 09 BC 55 4F D9 18 DB 8B B3 53 1D 6F 88 BE FE A4 BF BD F5 1C B1 E1 DF 5E 5D FA 83 FD 65 84 D3 7E 27 99 24 22 4F C4 F8 BB 6C 98 ED 50 D2 70 02 E8 BA 21 F3 5F 01 55 A0 8D 9E D2 76 71 40 32 AE EC DA 06 6C 17 FA 54 F1 C3 3E 5D AF 8B 33 2B 3C C0 77 14 90 A1 52 61 B2 DD 90 8F 53 F1 02 03 01 00 01
```
