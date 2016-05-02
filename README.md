#Administrative Note:
No current advisories.

#bparse.pl
Perl script for parsing battleye scripts.log entries and auto-generating exception entries. Designed for and only tested against the  Exile@ARMAIII platform in a CentOS-7 environment.

#Before Proceeding
Be smart about making changes to your battleye filters. Backup your scripts.txt file before you add entries generated by this script. Should you fail to do this, go ahead and change the intel on your Exile mission to reflect a high chance of QQ.

#Installation
1. Move bparse.pl to directory of choice.
2. Modify permissions for bparse.pl appropriate with your environment, currently bparse only needs to read your scripts.log file.

#Execution Syntax
./bparse.pl $file_location{this is the location for scripts.txt, usually within your battleye folder.} 

Execution Example:
<code>./bparse.pl /home/steam/steamcmd/arma3/battleye/scripts.log</code><br>

#Example Output
<code>[steam@localhost arma3]$ ./bparse.pl /home/steam/steamcmd/arma3/battleye/scripts.log</code><br>
<code>#38,!="(_this\nselect\n0)\nexecVM\n\"\A3\Structures_F\Wrecks\Scripts\Wreck_Heli_Attack_01.sqf\""</code><br>
<code>#38,!="(_this\nselect\n0)\nexecVM\n\"\A3\Structures_F\Wrecks\Scripts\Wreck_Heli_Attack_01.sqf\""</code><br>
<code>Total Entries parsed from /home/steam/steamcmd/arma3/battleye/scripts.log: 2</code><br>

#Optional Parameters
<b>Parameters are case sensitive!</b><br>
You may elect to include additional information in the output such as the date, IP, user, GUID, or all aforementioned fields in addition to the exception number and the recommended exception text. It is worth noting that the 'U' argument will provide a unique list of exceptions void of duplicates.<br><br>To display additional information use the following syntax for the secondary arguement: <code>-d[diugaU]</code><br>Example: <code>./bparse/home/steam/steamcmd/arma3/battleye/scripts.log -du</code><br>Example: <code>./bparse/home/steam/steamcmd/arma3/battleye/scripts.log -dgi</code><br>

Default Output Explained:
The script will display entries as they pertain to your battleye/scripts.log file, exception number first (#XXX) followed by the suggested exception text (!="xxx"). Exception suggestions have nested double-quotes escaped.

#Version
v1.4 (2016-05-02): Code modification to remedy extraneous newline (\n) character injection into the recommended exception text.

v1.3 (2016-04-14): Added -d[U] secondary argument option.

v1.2 (2016-04-14): Minor code tweaks, variable cleanup.

v1.1 (2016-04-14): Adds switches that can be used (not required) as a secondary arguement. They are (-d) as a display precursor, to be immediately followed by [diuga] to display the date, IP, user, GUID, or all fields parsed in addition to the exception number and suggested exception text.

v1.0 (2016-04-10): Initial release with basic output of exception number and recommended exception text.
