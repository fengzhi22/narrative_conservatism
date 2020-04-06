# narrative_conservatism
This repo contains the following contents:
  1. code:
      1_scrape: create two output files
          i) web_url_index.txt: a list of urls of HTML-format Edgar filings, excluding exhibits.
          ii) id_data.csv: a data set of filing headers, including accnum, file_type, cik, name, sic, fd, rp, fye, item8k, bazip and state
      2_clean: download all clean Edgar filings in .txt format. Cleaning steps are:
          i) delete nondisplay section
          ii) delete tables that contains more than 4 numbers
          iii) delete all HTML tags
      3_count: apply LM dictionary to count number of words in clean texts and save counts to text_data.csv
          i) text_data.csv: a data set of word counts with various dimensions: pos, neg, litigious, uncertainty, modal words etc.      
      4_statistics: merging id_data.csv and text_data.csv with Compustat and CRSP data, and create summary statistics (TABLE 1) of firm and text characteristics
    Note: The first three procedures (1_scrape, 2_clean and 3_count) involves information retrival for millions filings, so they take substantial amount of time. Therefore, they are split into various time periods to allow for several kernels working at the same time, in order to reduce processing time.
  
  2. filings: 
      i) raw data: COMPUSTAT and CRSP
      ii) processed data: web_url_index.txt, id_data.csv and text_data.csv
    Note: Due to hard drive storage limitation, the clean Edgar filings in .txt format are not stored in this folder, but can be obtained by running 2_clean.ipynb script, and are available upon request.
    
  3. output: figure and tables
  
