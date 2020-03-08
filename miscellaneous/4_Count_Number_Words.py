"""
This code counts the number of word repetitions
"""


"""
Import the libraries
"""
import csv
import numpy as np
import openpyxl as pyxl
import re
import os.path
import pandas as pd

"""
Directories:

WordList: Is the bag of words saved in a csv file. 

Text_10K_Directory: It is the 10K filings text files that are cleaned

List10K_StartYear_EndYear: These are the list of 10K filings in the text files from the Start Year to the End Year. These files are 
divided to different portions to make sure the Python does not face a Memory Error. 

Scores_10K_StartYear_EndYear: These are the excel files containing the counts of words in the bag of words.

output: It is the dta file containing the number of repition of words in the bag of words. 


"""
WordList='C:/Users/eparaske/Desktop/TextAnalysis/somethingWords.csv' # Word List file
Text_10K_Directory='C:/Users/eparaske/Desktop/TextAnalysis/10K/' # 10K Text files

# List10K_temp='C:/Users/eparaske/Desktop/TextAnalysis/Final Code/master10k_Final_temp.csv'
# Scores_10K_temp='C:/Users/eparaske/Desktop/TextAnalysis/temp/Scores/Scores_temp.csv'

Listing10K_Directory='C:/Users/eparaske/Desktop/TextAnalysis/Master10K-Breakdown/Files/'
List10K_93_98=Listing10K_Directory+'master10k_Final-93-98.csv' # List of 10K text files
List10K_99_00=Listing10K_Directory+'master10k_Final-99-00.csv'
List10K_01_02=Listing10K_Directory+'master10k_Final-01-02.csv'
List10K_03_04=Listing10K_Directory+'master10k_Final-03-04.csv'
List10K_05_06=Listing10K_Directory+'master10k_Final-05-06.csv'
List10K_07_08=Listing10K_Directory+'master10k_Final-07-08.csv'
List10K_09_10=Listing10K_Directory+'master10k_Final-09-10.csv'
List10K_11_12=Listing10K_Directory+'master10k_Final-11-12.csv'
List10K_13=Listing10K_Directory+'master10k_Final-13.csv'


Scores_10K_Directory='C:/Users/eparaske/Desktop/TextAnalysis/Master10K-Breakdown/Scores/'
Scores_10K_93_98=Scores_10K_Directory+'master10k_Final-93-98.xlsx' # List of 10K text files
Scores_10K_99_00=Scores_10K_Directory+'master10k_Final-99-00.xlsx'
Scores_10K_01_02=Scores_10K_Directory+'master10k_Final-01-02.xlsx'
Scores_10K_03_04=Scores_10K_Directory+'master10k_Final-03-04.xlsx'
Scores_10K_05_06=Scores_10K_Directory+'master10k_Final-05-06.xlsx'
Scores_10K_07_08=Scores_10K_Directory+'master10k_Final-07-08.xlsx'
Scores_10K_09_10=Scores_10K_Directory+'master10k_Final-09-10.xlsx'
Scores_10K_11_12=Scores_10K_Directory+'master10k_Final-11-12.xlsx'
Scores_10K_13=Scores_10K_Directory+'master10k_Final-13.xlsx'



output='C:/Users/eparaske/Desktop/TextAnalysis/somethingWords.dta'
"""
First we define the functions:

NumberOfOccurencesOfWordInText(word, text):  This code counts the number of word repetition. Returns the number of occurences of 
whole word(s) (case insensitive) in a text.

excel_style: This function returns the row and colum potions of the words in the final excel files for counting the words. 

Count_the_Number_of_Words: Count the number of words in each 10Ks in the List10K, save it in the Final_Count_Result for the words
in the WordList
"""

def NumberOfOccurencesOfWordInText(word, text):
    starte = "(?<![a-z])((?<!')|(?<=''))"
    ende = "(?![a-z])((?!')|(?=''))"
    pattern = (re.match('[a-z]', word, re.I) != None) * starte\
              + word\
              + (re.match('[a-z]', word[-1], re.I) != None) * ende
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

                    """
                    Here we clean the text from additional specific characters. 
                    """                    
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
We call the Count_the_Number_of_Words function for each listing, output and the wordlist
"""
#Count_the_Number_of_Words(List10K_temp,Scores_10K_temp,WordList)

Count_the_Number_of_Words(List10K_93_98,Scores_10K_93_98,WordList)
Count_the_Number_of_Words(List10K_99_00,Scores_10K_99_00,WordList)
Count_the_Number_of_Words(List10K_01_02,Scores_10K_01_02,WordList)
Count_the_Number_of_Words(List10K_03_04,Scores_10K_03_04,WordList)
Count_the_Number_of_Words(List10K_05_06,Scores_10K_05_06,WordList)
Count_the_Number_of_Words(List10K_07_08,Scores_10K_07_08,WordList)
Count_the_Number_of_Words(List10K_09_10,Scores_10K_09_10,WordList)
Count_the_Number_of_Words(List10K_11_12,Scores_10K_11_12,WordList)
Count_the_Number_of_Words(List10K_13,Scores_10K_13,WordList)


"""
Here, we merge the excel files and save it as a dta file in the output
"""

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
Scores_13=pd.read_excel(Scores_10K_13,'Table 1')
df.append(Scores_13)

df = pd.concat(df)

#writer = pd.ExcelWriter(output)
#df.to_excel(writer,'Sheet1')
#writer.save()

df.to_stata(output)





