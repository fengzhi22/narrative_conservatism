# -*- coding: utf-8 -*-
"""
Clean the text files
"""

"""
Import the Libraries
"""
import csv
import re
import os.path

"""
Directories:

Listing_10K: Is the excel file containing the 10K filings list.

Text_10K_Directory_Source: The 10K text files source directory. This folder contains the text file source.

Text_10K_Directory_Destination: The 10K text files destination directory. This folder contains the text file destination
after cleaning.

downloadagain: This excel file contains all the text files that are not downloaded. This is just to make sure we have 
all the available textfiles. 

"""

Listing_10K='C:/Users/eparaske/Desktop/TextAnalysis/Final Code/master10k_Final_temp.csv'
Text_10K_Directory_Source='C:/Users/eparaske/Desktop/TextAnalysis/temp/10K_temp_original/'
Text_10K_Directory_Destination='C:/Users/eparaske/Desktop/TextAnalysis/temp/10K_temp_original - clean/'
downloadagain='C:/Users/eparaske/Desktop/TextAnalysis/temp/downloadagain.csv'


"""
First we define the two function for cleaning the text files. 
cleanhtml: clears the html tags in the text files
NumberOfOccurencesOfWordInText: Count the number of repititions of the word in the text file. This code is considered to make sure the 
text file contains the HTML code. 
"""

def cleanhtml(raw_html):
  cleantext =re.sub('<[A-Za-z\/][^>]*>', '', raw_html)
  return cleantext

def NumberOfOccurencesOfWordInText(word, text):
    starte = "(?<![a-z])((?<!')|(?<=''))"
    ende = "(?![a-z])((?!')|(?=''))"
    pattern = (re.match('[a-z]', word, re.I) != None) * starte\
              + word\
              + (re.match('[a-z]', word[-1], re.I) != None) * ende
    return  len(re.findall(pattern, text, re.IGNORECASE))
    

Downloadagain=list()

"""
Count the Number of words
""" 
with open(Listing_10K) as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for line in reader:
        saveas =Text_10K_Directory_Source+ '-'.join([line[0],line[2], line[3]])+'.txt'
        saveas2 =Text_10K_Directory_Destination+ '-'.join([line[0],line[2], line[3]])+'.txt'
        
        temp=os.path.isfile(saveas)
        if temp==False:
            Downloadagain.append(saveas)
        else:
            print (line[0]+' '+line[3])
            f=open(saveas)
            try:  
                text=f.read()
                temp_num=NumberOfOccurencesOfWordInText('<DOCUMENT>\n<TYPE>10-K', text)
                if temp_num>0:                
                    text=("".join(text[text.index('<DOCUMENT>\n<TYPE>10-K')+1:text.index('</DOCUMENT>\n')]))
                    text=cleanhtml(text)
                    text=text.replace('amp;','')
                    text=text.replace('&nbsp;',' ')
                    text=text.replace('&#146;','\'')
                    text=text.replace('&#147;','\"')
                    text=text.replace('&#148;','\"')
                    text=text.replace('&#9;','  ')
                    f1=open(saveas2,'w')
                    f1.write(text)
                    f1.close()
                else:
                    Downloadagain.append(saveas) 
            except:
                print 'It does not read'
                Downloadagain.append(saveas)

"""
Save the word counts
""" 
import csv
resultFile = open(downloadagain,'wb')
wr = csv.writer(resultFile, dialect='excel')
wr.writerows(Downloadagain)





