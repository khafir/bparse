# bparse.pl
Perl script for parsing battle scripts.log entries and auto-generating exception entries. Designed for and only tested against the  Exile@ARMAIII platform in a CentOS-7 environment.

#Before Proceeding
Be smart about making changes to your battleye filters. Backup your scripts.txt file before you add entries generated by this script. Should you fail to do this, go ahead and chane the intel on your Exile mission to reflect a high chance of QQ.

#Installation
1. Move bparse.pl to directory of choice.
2. Modify permissions for bparse.pl appropriate with your environment, currently bparse only needs to read your scripts.log file.

#Execution Syntax
./bparse.pl $file_location{this is the location for scripts.txt, usually within your battleye folder.} 

Execution Example:
./bparse.pl /home/steam/steamcmd/arma3/battleye/scripts.log

#Example Output
<code>[steam@localhost arma3]$ ./bparse.pl /home/steam/steamcmd/arma3/battleye/scripts.log</code><br>
<code>#38,!="(_this\nselect\n0)\nexecVM\n\"\A3\Structures_F\Wrecks\Scripts\Wreck_Heli_Attack_01.sqf\""/code><br>
<code>#38,!="(_this\nselect\n0)\nexecVM\n\"\A3\Structures_F\Wrecks\Scripts\Wreck_Heli_Attack_01.sqf\""</code>

Total Entries parsed from /home/steam/steamcmd/arma3/battleye/scripts.log: 2

Output Explained:
The script will display entries as they pertain to your battleye/scripts.log file, exception number first (#XXX) followed by the suggested exception text (!="xxx"). Exception suggestions have nested double-quotes escaped.
