# -*- coding: utf-8 -*-
# Beat tracking example
from __future__ import print_function
import librosa
import essentia
import essentia.standard as es
from pydub import AudioSegment
import numpy as np

# 1. Get the file path to the included audio example

# 2. Load the audio as a waveform `y`
#    Store the sampling rate as `sr`
#captura da musica
arq = open('/home/douglas/Música/musicas/wav/felizes/felizes.txt','r')
lines = arq.readlines()
arq.close()

lista = []

count=0
for l in lines:
    #carregamento dos arquivos
    music, erro = l.split("\n",1)
    #VERIFIQUE O CAMINHO, POR FAVOR
    y, sr = librosa.load('/home/douglas/Música/musicas/wav/felizes/'+music)
    oenv = librosa.onset.onset_strength(y=y, sr=sr)
    # Detect events without backtracking
    onset_raw = librosa.onset.onset_detect(onset_envelope=oenv,backtrack=False)
    # Backtrack the events using the onset envelope
    onset_bt = librosa.onset.onset_backtrack(onset_raw, oenv)
    maximum = librosa.frames_to_time(onset_bt, sr=sr)
    minimum = librosa.frames_to_time(onset_raw, sr=sr)
    
    soma=0
    for i in range(len(minimum)-1):
        sound = AudioSegment.from_wav('/home/douglas/Música/musicas/wav/felizes/'+music)
        parte1 = sound[maximum[i]*1000:minimum[i+1]*1000]
        parte1.export('parte1.wav',format="wav")
        features, features_frames = es.MusicExtractor(lowlevelStats=['mean', 'stdev'],
                                                rhythmStats=['mean', 'stdev'],
                                                tonalStats=['mean', 'stdev'],
                                                lowlevelWindowType='hann',lowlevelHopSize=512,lowlevelFrameSize=2048)('parte1.wav')

        # See all feature names in the pool in a sorted order
        soma=+float(features['lowlevel.spectral_energy.mean'])
        lista.append(soma)
    print(music)
    
arq = open('/home/douglas/Documentos/tcc_code/resultado/resultados_felizes.csv','r')
musics = arq.readlines()
arq.close()

count=0
arq = open('/home/douglas/Documentos/tcc_code/resultado/resultados_felizes.csv','w')
for m in musics:
    music, erro = m.split("\n",1)
    print(music+","+str(lista[count])+"\n")
    arq.write(music+","+str(lista[count])+"\n")
    count+=1
