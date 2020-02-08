# Wolcen Extractor

/!\ Windows only /!\\ 

This program allows the unpacking of Wolcen `.pak` files and the decryption of CryEngine XML files. 
It is only usable from the command line (`cmd`) on Windows (Works for sure on Windows 10, not sure about previous versions).

For this program to work, you need to provide the latest Wolcen's build CryEngine RSA Key. 
I'll try to keep it up to date for as long as I can (and as long as I can manage to retrieve it, Wolcen might change some things in the future.)
If you can't find a release for the latest version of Wolcen, you can try to extract the RSA Key yourself by following [this tutorial](http://atom0s.com/forums/viewtopic.php?f=11&t=223).
After you found it, you can just copy paste it in the `wolcen.rsa` file at the root of the folder. A new patched PakDecrypt executable will be automatically created when you run the program.

## Installation

Download the latest release ZIP file and extract it in it's own directory, wherever you want.

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

- Sometimes, the execution hands during a DDS conversion phase, in this case, just hitting enter usually solves the issue.
- Some `DDS` files just can't be converted by image magick, and will be left as is. You can still open those in Photoshop, Gimp, Paint.net (with the necessary plugin) or a DDS Viewer or converter.

## Dev

Clone the repository and install Ruby 2.1.9.

```
bundle install
ruby src/main.rb some\path\to\your\source some\path\to\your\destination
```

## Build 

Requires ruby 2.1.9 because of ocra's compatibility. Also this script doesn't require more so that's fine.

```
gem install bundler
gem install ocra
bundle install
ocra src/main.rb --verbose --gem-full --no-dep-run --add-all-core --gemfile .\Gemfile
```


## Roadmap: 

- Rename .raw
- Image magick dds conversion
    - bin\magick mogrify -format png .\test\destination\Libs\UI\u_resources\Minimap\wolcen_act1.dds

## Inspiration and Resources

Thanks to atom0s for all his knowledge and his great tutorials.
- http://atom0s.com/forums/viewtopic.php?f=11&t=223
- https://zenhax.com/viewtopic.php?p=41911#p41911

### Current Wolcen PakDecrypt RSA Key:

```
    0x30, 0x81, 0x89, 0x02, 0x81, 0x81, 0x00, 0xDD, 0x6A, 0x61, 0x1E, 0x84, 0x79, 0xD7, 0xAE, 0x91,
    0x60, 0x50, 0x6A, 0x7E, 0x9A, 0x99, 0x74, 0x95, 0x27, 0x28, 0x06, 0x29, 0x4F, 0x1E, 0x4D, 0xDC,
    0xC7, 0x52, 0x46, 0x1F, 0x5F, 0x63, 0x11, 0x7B, 0x61, 0xE9, 0x06, 0x50, 0x42, 0x15, 0x97, 0xFD,
    0x03, 0x04, 0xB1, 0xBE, 0x89, 0x2B, 0xC3, 0x4E, 0xDA, 0xD1, 0x7E, 0xE7, 0x5C, 0x18, 0xE4, 0x21,
    0x69, 0x03, 0xE2, 0x7D, 0x7A, 0xF5, 0x83, 0xA6, 0x50, 0x5E, 0x72, 0x00, 0xEF, 0xCA, 0xE5, 0x07,
    0x67, 0x5C, 0xBB, 0x77, 0x7A, 0xE7, 0x74, 0xFE, 0xC0, 0xF9, 0x99, 0xFA, 0x41, 0x1E, 0x80, 0x7C,
    0x54, 0xBB, 0x18, 0xCB, 0xFC, 0x86, 0x48, 0x35, 0xBC, 0xDD, 0xC8, 0x6F, 0x34, 0x97, 0x6C, 0xB8,
    0x82, 0x4B, 0x76, 0x94, 0x76, 0x34, 0xBF, 0x2D, 0x70, 0x52, 0x2B, 0xBA, 0x15, 0x35, 0x36, 0x6E,
    0x06, 0xD9, 0x88, 0xD4, 0x00, 0x70, 0x9D, 0x02, 0x03, 0x01, 0x00, 0x01 
```