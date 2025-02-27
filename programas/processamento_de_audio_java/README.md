# jMIR 3.1

Principal Designer: Cory McKay  
CIRMMT, Marianopolis College, McGill University and the University of Waikato  
Copyright (C) 2018 (GNU GPL)  


### OVERVIEW

jMIR is an open-source software suite implemented in Java for use in music
information retrieval (MIR) research. It can be used to study music in the 
form of audio recordings, symbolic encodings and lyrical transcriptions, and
can also mine cultural information from the Internet. It also includes tools
for managing and profiling large music collections and for checking audio for
production errors. jMIR includes software for extracting features, applying
machine learning algorithms, applying heuristic error error checkers, mining 
metadata and analyzing metadata.

The primary emphasis of jMIR is on providing software for general research in
automatic music classification and similarity analysis. The main goals of the
project are as follows:

- Make sophisticated pattern recognition technologies accessible to music
researchers with both technical and non-technical backgrounds.
- Eliminate redundant duplication of effort.
- Increase cooperation and communication between research groups.
  - Facilitate iterative development and sharing of new MIR technologies.
  - Facilitate objective comparisons of algorithms.
- Facilitate research combining high-level, low-level and cultural musical
features (i.e. symbolic, audio and web-mined features).

In order to meet these goals, all aspects of jMIR are open source and distributed
free under a GNU General Public License. The software is well-documented and
include GUIs in order to increase general usability. A special emphasis has been
placed on software architectures that facilitate extensibility for those
technically inclined users who wish to modify or add to the software.

Each of the components comprising the jMIR software suite may be used entirely
separately or as an integrated whole. The components communicate with each other
using files in either ACE XML or Weka ARFF formats. The components are as follows:

Data Mining and Machine Learning

- ACE: Pattern recognition software that utilizes meta-learning. Evaluates,
trains and uses a variety of classifiers, classifier ensembles and 
dimensionality reduction algorithms based on the needs of each particular 
research problem.
- ACE XML: Standardized file formats for representing information related to
automatic music classification, including feature values, feature metadata, 
insance labels and class ontologies.
- jMIRUtilities: Tools for performing miscellaneous tasks, such as labelling
instances, extracting data from Apple iTunes XML files, merging features
extracted from different sources, etc.

Feature Extraction

- jSymbolic: Software for extracting high-level features from symbolic music encodings.
- jAudio: Software for extracting low and high-level features from audio recordings.
- jWebMiner: Software for extracting cultural features from the internet.
- jLyrics: Software for mining lyrics from the web and extracting textual
features from them.

Education and Audio Production

- jProductionCritic: Educational software for automatically finding technical
redording and production errors in audio files.

Data and Metadata

- jSongMiner: Software for identifying unknown audio and extracting metadata
about songs, artists and albums from various web services and embedded
sources.
- jMusicMetaManager: Software for profiling music collections and detecting
metadata errors and redundancies.
- jMei2Midi: Library for converting MEI to MIDI. Can retain and communicate
MEI information that cannot be represented in MIDI.
- Codaich, Bodhidharma MIDI and SLAC: Labeled datasets for training, testing
and evaluating MIR systems.

Legacy

- Bodhidharma: MIREX 2005-winning software for classifying MIDI recordings by genre. 
The ancestor of ACE and jSymbolic.

This distribution contains the source code for all of the above jMIR software.
Each is packaged in a separate folder holding the associated NetBeans project.
Each folder also contains extensive additional information, including README
files and, in some cases, HTML manuals. The only exception is the Third-Party-Jars
folder, which contains third-party software libraries used by the other jMIR
components.

More information is available on the jMIR web site: http://jmir.sourceforge.net.

Please contact Cory McKay (cory.mckay@mail.mcgill.ca) or one of the jMIR 
co-designers with any bug reports or questions relating to jMIR. 


### LICENSING AND LIABILITY

This software is free software; you can redistribute it
and/or modify it under the terms of the GNU General 
Public License as published by the Free Software Foundation.

This software is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE. See the GNU General Public License for more details.

You may obtain a copy of the GNU General Public License by writing 
to the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, 
MA 02139, USA.

Various jMIR components make use of third-party software. Details
are provided in the folder corresponding to each jMIR component.