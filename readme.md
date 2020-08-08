# Funip
Making Ipv4 fun again! 

Who needs DNS servers? 

Funip is a tool that converts between ip4 ip-addresses to a human readable format.

Example:
```
$./funip.exe ip 192.168.0.192
sables.abrasax
```

```
$./funip.exe funip sables.abrasax
192.168.0.192
```

Incidentally, you can find my website at `salmine.suddle`.

## CLI
```
Convert between funips and ipv4 addresses.

  funip.exe SUBCOMMAND

=== subcommands ===

  funip-to-ip  Convert a funip to ipv4-address format.
  ip-to-funip  Convert an ipv4-address to a funip format.
  version      print version information
  help         explain a given subcommand (perhaps recursively)
```
## Building
You will need to download the list of all english words `words.txt` from the following repository and place it at the project root:
```https://github.com/dwyl/english-words```
