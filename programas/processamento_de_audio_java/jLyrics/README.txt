==========================================================================
 jLyrics 1.1.2
 jLyrics Java code by Cory McKay
 jLyrics Python code by John Ashley Burgoyne
 lyricFetcher code by Jason Hockman and Jordan Smith
 Copyright (C) 2017 (GNU GPL)
==========================================================================


-- OVERVIEW -- 

jLyrics is a set of open source software tools for automatically mining lyrics 
from the web and extracting features from the lyrics once they have been acquired.
It should be noted that the current release of jLyrics is only a prototype,
and will be developed and polished significantly more in the future.

jLyrics is part of the the jMIR music classification research software suite.
More information on jMIR is available at http://jmir.sourceforge.net. The
current release version can perform the following tasks:

Although jLyrics has not yet been as cleanly packaged as the other jMIR components, 
due to its status as a new project, it is nonetheless currently fully functional
and available for use. jLyrics currently consists of the following three components:

- jLyrics (Java component): The primary framework which all of the jLyrics 
functionality will eventually be ported into. It includes many of the standard jMIR 
feature extractor advantages, such as automatic feature extraction scheduling and
resolution and a highly extensible architecture. It does not yet include a GUI,
however. Nineteen features are currently implemented directly in the jLyrics Java 
framework, and more will be added soon. This software also includes functionality
for collecting lists of the most commonly occurring words in sets of lyrics, which 
can be a useful tool for developing new features.

- jLyrics (Python component): A set of additional features that have been prototyped
using Python and various existing third-party software libraries. Examples of types
of features extracted in include readability statistics, part-of-speech statistics,
topic models, letter bigrams, etc.

- lyricFetcher: Ruby scripts for mining lyrics from the Internet. One script mines
the lyrics from LyricWiki, and the other mines them from LyricsFly. Lyrics are mined
based on queries consisting of artist names and song names, and lyrics are
pre-processed upon retrieval. For example, many lyrics are abridged by providing a 
label for the first occurrence of a section (e.g., �chorus,� �hook,� �refrain,� etc.) 
and repeating only this label when the section reoccurs. lyricFetcher automatically 
searches for and expands such sections.


-- GETTING MORE INFORMATION --

More information on jMIR is available at http://jmir.sourceforge.net.

Please contact Cory McKay (cory.mckay@mail.mcgill.ca), John Ashley Burgoyne 
(ashley@music.mcgill.ca), Jason Hockman (jason.hockman@mail.mcgill.ca) or Jordan
Smith (jordan.smith2@mail.mcgill.ca) with any bug reports or questions relating to
jLyrics. 


-- LICENSING AND LIABILITY --

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT 
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You may obtain a copy of the GNU General Public License by writing to the Free
Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


-- COMPATIBILITY --

This software is partly written in Java, which means that it can theoretically be
run on any system that has the Java Runtime Environment (JRE) installed on it. It 
is recommended that this software be used with Windows, however, as it was 
developed and tested under the Windows operating system, and the interface's 
appearance was developed under Windows. Although the software should 
theoretically run under OS X, Linux, Solaris or any other operating system with
the JRE installed on it, users should be advised that the software has not yet 
been fully tested on other platforms, so difficulties may be encountered.

This software was developed with version 1.6.0_16 of the JDK (Java Development 
Kit), so it is suggested that the corresponding version or higher of the JRE be
installed on the user's computer.

Technologies other than Java were used to implement lyricFetcher and the
non-Java components of jLyrics, including Ruby and Python.


-- INSTALLING THE JAVA RUNTIME ENVIRONMENT --

If your system already has the JRE installed, as will most typically be the
case, you may skip this section. If not, you will need to install the JRE in
order to run this project. The JRE can be downloaded for free from the Java web
site. The JDK typically includes the JRE, or the JRE can simply be installed
alone.

When the JRE download is complete, follow the installation instructions that
come with it in order to install it.


-- INSTALLING THE PROJECT --

The project can be accessed at http://jmir.sourceforge.net. This distribution
includes a pre-compiled Jar file, the source code and extensive documentation. 
All of this is delivered in a zipped file, from which the project files can be
extracted.

There are two versions of the project, namely the developer version and the
user version. The user version contains everything needed to run the project,
but does not include any source code. The developer version does include
source code, presented in the form of a NetBeans project.

The user version unzips into a single directory. Installation simply involves 
copying this directory into any desired location.

The following directories are contained in the developer zip file:

- jLyrics: The jLyrics project, presented in the form of a NetBeans project.
Contains the following directories and files:
	- dist: Contains a pre-compiled jLyrics.jar file (and associated
	libraries) for direct inclusion in other projects.
	- javadoc: Javadoc documentation for the project source code.
	- jLyrics_Python: Contains the separate Python components of the jLyrics
	project (this operates independently of the Java portion)
	- lyricFetcher: Contains the separate Ruby lyricFetcher component of
	the jLyrics project (this operates independently of the Java portion)
	- nbproject: NetBeans project files. This is only relevant to those
	wishing to use the software in a NetBeans IDE context; it is certainly
	possible to use the software in other development environments as well.
	- src: The project's source code.
	- build.xml: NetBeans build instructions. Only relevant if using the
	NetBeans IDE.
	- GNU_GPL.txt: Licensing information.
	- manifest.mf: The manifest used when building the project Jar file.
	- README.txt: Basic overall documentation of the project.
- Third_Party_Jars: Contains the distributable third-party software used by 
the project. Also includes the jar files for other jMIR projects that this
project has as adependencies, if any. These need to be included in the project's
build (in the NetBeans context, this means adding the jar files found here as 
libraries).


-- RUNNING THE jLyrics JAVA COMPONENT -- 

A file named "jLyrics.jar" is produced upon installation.
The software is accessed via the command line (e.g. the DOS
prompt). To access DOS under Windows, for example, go to the Start 
Menu, select Run and type "cmd". Then use the "cd" command to move to
the directory that contains the jLyrics.jar file. In that directory, 
type:

	java -jar jLyrics.jar ...

where "..." are the appropriate command line arguments.

The user specifies a directory containing .txt files that each contains
the lyrics for one song. The features extracted from these files are
then saved as ACE XML 1.1 Feature Value and Feature Definition files,
each of which are saved at locations specified by the user. Results 
may alternatively be saved as a Weka ARFF file if preferred.

The valid command line arguments are as follows:

1) Directory path to parse for lyrics files
2) File path to save ACE XML 1.1 Feature Values file to
3) File path to save ACE XML 1.1 Feature Definitions file to
 
OR

1) Directory path to parse for lyrics files
2) File path to save Weka ARFF file to

OR (for generating profiles)

1) -profile
2) Directory path to parse for lyrics files
3) Path to save generated report to

OR (for generating profiles)

 1) -profile
 2) Directory path to parse for lyrics files
 3) Path of a file specifying unique classes
 4) Path of a file specifying instance classes
 5) Path of a file specifying instance identifiers
 6) Path to save generated reports to

It should be noted that the JRE does not always allocate sufficient
memory for jLyrics to process large music collections. Running 
jLyrics as discussed above could therefore result in an out of memory 
error (although this is relatively rare).

It is therefore sometimes preferable to manually allocate a greater
amount of memory to jLyrics before running it. 250 MB should be more
than enough for most situations. This can be done by entering the 
following at the command prompt:

	java -ms16M -mx250M -jar jLyrics.jar ...


-- ADDING FEATURES TO THE JAVA jLyrics COMPONENT --

1) Implement a class for the new feature in the jlyrics/features
   directory. It must extend the LyricsFeatureExtractor abstract class.
2) Add a reference to the new class to the populateFeatureExtractorsToApply 
   method in the LyricsFeatureProcessor class.


-- ADDITIONAL FEATURES EXTRACTED USING PYTHON --

Prototype Python jLyrics code has been written to extract a number of lyrical
features that are not extracted by the Java implementation of jLyrics yet.
There are plans to eventually incorporate these into the jLyrics Java
framework, but they are presented here in Python form for those who
may wish to use them in the meantime.

This script is called "lyric_features.py", and is included in the
"jLyrics_Python" directory. Assuming Python is installed on the user's
computer, running "lyric_features.py [DIRECTORY_NAME]" will print an
ACE XML 1.1 Feature Value file to standard output with the features 
corresponding to the lyrics files in the specified directory.

Readability statistics require the Flesh readability calculator. At 
the time of writing, the JAR file is available from 
http://flesh.sourceforge.net.

Part-of-speech statistics require the Stanford tagger (also Java-
based). At the time of writing, this tagger is available from
http://nlp.stanford.edu/software/tagger.shtml.

The R package topic models, available from CRAN, were also used to
calculate the probability of topic membership for each song. Any
alternative package could work: lyrics_features.py simply looks for CSV 
files named 'topics10.dat' and "topics24.dat". The CSV file should have
one  row per song in the directory.

Mathematica was used to compute the principal components of the letter 
bigrams. Any alternative package (e.g, MATLAB, Octave, or R) could 
work: lyrics_features.py simply looks for a CSV file named 
"bigram_components.dat". For use with the external program, 
lyric_features.py outputs a CSV file with all letter-bigram 
frequencies in bigram_frequencies.dat. Both CSV files should have one 
row per song in the directory.


-- MINING LYRICS FROM THE WEB USING lyricFetcher --

jLyrics also includes functionality for mining lyrics from two web
sites, namely LyricWiki (http://lyrics.wikia.com/Main_Page) and
LyricsFly (http://lyricsfly.com). The associated Ruby code is found 
in the "lyricFetcher" directory, along with explanatory README
files. There are also eventual plans to incoroporate this functionality
into the general jLyrics Java functionality in order to increase
ease of use and compatibility. 


-- UPDATES SINCE VERSION 1.0 -- 

jLyrics 1.1.2
- Updated support libraries.
- Minor documentation updates.

jLyrics 1.1
- Fixed a bug related to parsing ACE XML files.
- Updated the ACE and UtilityClasses support libraries.