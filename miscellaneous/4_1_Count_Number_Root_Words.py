# -*- coding: utf-8 -*-
"""
Created on Sun Jun 19 17:43:19 2016

@author: abi
"""

# -*- coding: utf-8 -*-
"""
This code counts the number of word repetitions
"""

import csv
import numpy as np
import openpyxl as pyxl
import re
import os.path

"""
Directories
"""
WordList='C:/Users/abi/Dropbox/0PROJECTS/textualanalysis/Bag_of_words.csv' # Word List file
Text_10K_Directory='C:/Users/abi/Dropbox/ppp_base/10K/' # 10K Text files


List10K_93_98='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Files/master10k_Final-93-98.csv' # List of 10K text files
List10K_99_00='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Files/master10k_Final-99-00.csv'
List10K_01_02='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Files/master10k_Final-01-02.csv'
List10K_03_04='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Files/master10k_Final-03-04.csv'
List10K_05_06='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Files/master10k_Final-05-06.csv'
List10K_07_08='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Files/master10k_Final-07-08.csv'
List10K_09_10='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Files/master10k_Final-09-10.csv'
List10K_11_12='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Files/master10k_Final-11-12.csv'

Scores_10K_93_98='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Scores/master10k_Final-93-98.xlsx' # List of 10K text files
Scores_10K_99_00='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Scores/master10k_Final-99-00.xlsx'
Scores_10K_01_02='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Scores/master10k_Final-01-02.xlsx'
Scores_10K_03_04='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Scores/master10k_Final-03-04.xlsx'
Scores_10K_05_06='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Scores/master10k_Final-05-06.xlsx'
Scores_10K_07_08='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Scores/master10k_Final-07-08.xlsx'
Scores_10K_09_10='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Scores/master10k_Final-09-10.xlsx'
Scores_10K_11_12='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Scores/master10k_Final-11-12.xlsx'

output='C:/Users/abi/Dropbox/ppp_base/Final code/Master10K-Breakdown/Scores/Output.dta'


"""
   This code counts the number of word repetition. Returns the nb. of occurences of whole word(s) (case insensitive) in a text.
"""
def NumberOfOccurencesOfWordInText(word, text):
    pattern = word
    return  len(re.findall(pattern, text, re.IGNORECASE))

def excel_style(row, col):
    """ Convert given row and column number to an Excel-style cell name. """
    LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    result = []
    while col:
        col, rem = divmod(col-1, 26)
        result[:0] = LETTERS[rem]
    return ''.join(result) + str(row)

"""
Count the Number of words
""" 
def Count_the_Number_of_Words(List10K,Final_Count_Result,WordList): 
    table = np.array(['CIK','Date'])
    with open(WordList) as csvfile:
                reader1 = csv.reader(csvfile, delimiter=',')
                for line1 in reader1:
                    word=line1[0]
                    table=np.append(table,word)
    NumberofCol=len(table)
    Words=table
    
    Downloadagain=list()
    with open(List10K) as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for line in reader:
            saveas =Text_10K_Directory+ '-'.join([line[0],line[2], line[3]])+'.txt'
            temp=os.path.isfile(saveas)
            if temp==True:
    
                print (line[3])
                
                
                l=list()        
                l.append(line[0])    
                l.append(line[3])      
                f=open(saveas)
                try:  
                    text=f.read()
                    chars = [',', '.']
                    text=text.translate(None, ''.join(chars))
                    for num in range(2,NumberofCol):
                            word=Words[num]
                            word=word.strip()
                            l.append(0)
                            l[-1]=NumberOfOccurencesOfWordInText(word,text)
                    table = np.vstack((table,l))
                    f.close()
                except:
                    print 'It does not read'
                    Downloadagain.append(saveas)
    
    wb = pyxl.Workbook()
    ws = wb.active
    ws.title = 'Table 1'
     
    tableshape = np.shape(table)
     
    for i in range(tableshape[0]):
        for j in range(tableshape[1]):
            ws[excel_style(i+1, j+1)] = table[i, j]
     
    wb.save(Final_Count_Result)

""" 
df=pd.DataFrame(data=table[1:,0:], columns=table[0,0:]) 
df.to_stata(Final_Count_Result) 
"""

Count_the_Number_of_Words(List10K_93_98,Scores_10K_93_98,WordList)
Count_the_Number_of_Words(List10K_99_00,Scores_10K_99_00,WordList)
Count_the_Number_of_Words(List10K_01_02,Scores_10K_01_02,WordList)
Count_the_Number_of_Words(List10K_03_04,Scores_10K_03_04,WordList)
Count_the_Number_of_Words(List10K_05_06,Scores_10K_05_06,WordList)
Count_the_Number_of_Words(List10K_07_08,Scores_10K_07_08,WordList)
Count_the_Number_of_Words(List10K_09_10,Scores_10K_09_10,WordList)
Count_the_Number_of_Words(List10K_11_12,Scores_10K_11_12,WordList)

import pandas as pd
df = []
Scores_93_98=pd.read_excel(Scores_10K_93_98,'Table 1')
df.append(Scores_93_98)

Scores_99_00=pd.read_excel(Scores_10K_99_00,'Table 1')
df.append(Scores_99_00)

Scores_01_02=pd.read_excel(Scores_10K_01_02,'Table 1')
df.append(Scores_01_02)

Scores_03_04=pd.read_excel(Scores_10K_03_04,'Table 1')
df.append(Scores_03_04)

Scores_05_06=pd.read_excel(Scores_10K_05_06,'Table 1')
df.append(Scores_05_06)

Scores_07_08=pd.read_excel(Scores_10K_07_08,'Table 1')
df.append(Scores_07_08)

Scores_09_10=pd.read_excel(Scores_10K_09_10,'Table 1')
df.append(Scores_09_10)

Scores_11_12=pd.read_excel(Scores_10K_11_12,'Table 1')
df.append(Scores_11_12)

df = pd.concat(df)
df.to_stata(output) 








