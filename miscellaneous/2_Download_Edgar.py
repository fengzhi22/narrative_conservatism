# -*- coding: utf-8 -*-
"""
This code downloads the 10-k filings
"""

"""
Import 10K libraries
"""
import csv
import ftplib

"""
Set the Source and Save folder
Source_10K: Set the excel file containing the 10K addresses (We save the list of 10K files and their ftp address in the master10k_Final.csv)
save_10K: Set the final folder to download the 10K filings

"""
source_10K='C:/Users/eparaske/Desktop/TextAnalysis/Final Code/master10k_Final_temp.csv'
# source_10K='C:/Users/abi/Dropbox/ppp_base/Final code/Final code/Final code/master10k_Final_temp.csv'
save_10K='C:/Users/eparaske/Desktop/TextAnalysis/temp/10K_temp_original/'


"""
The ftp address is set to ftp.sec.gov
and it is logged in
"""
ftp = ftplib.FTP('ftp.sec.gov')
ftp.login()

"""
In the next step, we download the 10K text files
The name of the text files are set as cik-10-K-date (for example: 1000209-10-K-5-Mar-14.txt )
"""

with open(source_10K) as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for line in reader:
        saveas =save_10K+ '-'.join([line[0],line[2], line[3]])+'.txt'
        print ('-'.join([line[0],line[2], line[3]])+'.txt')        
        # Reorganize to rename the output filename.
        path = line[4].strip()
        with open(saveas, 'wb') as f:
            
            ftp.retrbinary('RETR %s' % path, f.write)

ftp.close()